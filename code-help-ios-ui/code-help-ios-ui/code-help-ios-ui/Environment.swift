//
//  Environment.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 7.9.23.
//

import SwiftUI
import Authentication
import ForumApi
import CodeHelpApi
import CoreData

class ClientContainer: ObservableObject {
    var forumClient: ForumClient
    var codeHelpClient: CodeHelpClient
    
    
    init(with authService: AuthenticationService) {
        self.forumClient = ForumClient(with: [AuthenticationMiddleware(authService)])
        self.codeHelpClient = CodeHelpClient(with: [AuthenticationMiddleware(authService)])
    }
    
    private init(with authService: AuthenticationService, in preview: Bool) {
        self.forumClient = ForumClientStub.create([AuthenticationMiddleware(authService)])
        self.codeHelpClient = CodeHelpClientStub.create([AuthenticationMiddleware(authService)])
    }
    
    public static func createStubClientContainer(with authService: AuthenticationService) -> ClientContainer {
        .init(with: authService, in: true)
    }
}

class AccentColorController: ObservableObject {
    @Published var accentColor: Color;
    private var context: NSManagedObjectContext
    
    init(_ persistenceController: PersistenceController) {
        let context = persistenceController.container.viewContext
        
        self.context = context
        self.accentColor  = Self.loadColor(context) ?? Color.accentColor
    }
    
    private static func loadColor(_ context: NSManagedObjectContext) -> Color? {
        context.getUserSettings()?.accentColor?.toAccentColor()?.toColor()
    }
    
    private func loadColor() -> Color? {
        self.context.getUserSettings()?.accentColor?.toAccentColor()?.toColor()
    }
    
    public func reloadAccentColor() {
        self.objectWillChange.send()
        self.accentColor = loadColor() ?? Color.accentColor
    }
}

struct EnvironmentObjectState<Content: View>: View {
    
    @StateObject private var authenticationService: AuthenticationService
    @StateObject private var webClient: ClientContainer
    @StateObject private var accentColorController: AccentColorController
    private let persistenceController: PersistenceController
    
    @ViewBuilder var content: () -> Content
    
    private var accentColor: Color {
        persistenceController.container.viewContext.getUserSettings()?.accentColor?.toAccentColor()?.toColor() ?? Color.accentColor
    }
    
    init(authenticationService: AuthenticationService, webClient: ClientContainer, persistenceController: PersistenceController, content: @escaping () -> Content) {
        self.content = content
        self.persistenceController = persistenceController
        self._authenticationService = StateObject(wrappedValue: authenticationService)
        self._webClient = StateObject(wrappedValue: webClient)
        self._accentColorController = .init(wrappedValue: .init(persistenceController))
    }
    
    var body: some View {
        content()
            .tint(accentColorController.accentColor)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(authenticationService)
            .environmentObject(webClient)
            .environmentObject(accentColorController)
    }
}

struct AttachEnvironmentObjects<Content: View>: View {
    private let authenticationService: AuthenticationService
    private let webClient: ClientContainer
    private let persistenceController = PersistenceController.shared
    
    @ViewBuilder var content: () -> Content
    
    init(content: @escaping () -> Content) {
        self.content = content
        let newAuthenticationService = AuthenticationService(Config.getAuthenticationConfig())
        self.authenticationService = newAuthenticationService
        self.webClient = ClientContainer(with: newAuthenticationService)
    }
    
    var body: some View {
        EnvironmentObjectState(
            authenticationService: authenticationService,
            webClient: webClient,
            persistenceController: persistenceController
        ) {
            content()
        }
    }
}

struct AttachStubEnvironmentObjects<Content: View>: View {
    private let authenticationService: AuthenticationService
    private let webClient: ClientContainer
    private let persistenceController = PersistenceController.preview
    
    @ViewBuilder var content: () -> Content
    
    init(content: @escaping () -> Content) {
        self.content = content
        let newAuthenticationService = AuthenticationStub.create()
        self.authenticationService = newAuthenticationService
        self.webClient = ClientContainer.createStubClientContainer(with: newAuthenticationService)
    }
    
    var body: some View {
        EnvironmentObjectState(
            authenticationService: authenticationService,
            webClient: webClient,
            persistenceController: persistenceController
        ) {
            content()
        }
    }
}
