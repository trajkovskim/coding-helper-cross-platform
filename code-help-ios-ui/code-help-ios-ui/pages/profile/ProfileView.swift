//
//  ProfileView.swift
//  code-help-ios-ui
//
//  Created by Martin Trajkovski on 29.8.23.
//

import SwiftUI
import Authentication
import CodeHelpApi

struct Stat: Identifiable {
    let id = UUID()
    let name: String
    let value: String
}

enum StatLinkType {
    case stats
    case saved
    case history
    case settings
}

struct StatLink: Identifiable {
    let id = UUID()
    let name: String
    let type: StatLinkType
}

struct ProfileView: View {
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var authenticationService: AuthenticationService
    @EnvironmentObject private var webClient: ClientContainer

    @State private var stats: [Stat] = [
        .init(name: "Solved", value: "0"),
        .init(name: "Easy", value: "0"),
        .init(name: "Medium", value: "0"),
        .init(name: "Hard", value: "0")
    ]
    
    private var links: [StatLink] = [
        .init(name: "Stats", type: .stats),
        .init(name: "Saved", type: .saved),
        .init(name: "History", type: .history),
        .init(name: "Settings", type: .settings)
    ]
    
    @State var isDone = false
    var body: some View {
        NavigationTitleView(title: "Profile") {
            GeometryReader { g in
                ScrollView {
                    VStack {
                        VStack {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .padding()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            if authenticationService.state.isAuthorized() {
                                Text(authenticationService.tokenState?.username ?? "")
                                    .bold()
                                    .font(Font.system(size: 21))
                            } else {
                                Button("Login") {
                                    authenticationService.login()
                                    isDone.toggle()
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            
                        }
                        .padding(.vertical, 20)
                        .background(Color.secondaryBackground)
                        .cornerRadius(10)
                        .padding()
                        .frame(maxHeight: 220)
                    }

                    UserStatsView(stats: stats)
                    .frame(height: 20 + (48 * CGFloat(stats.count)))
                    .scrollDisabled(true)
                    .scrollContentBackground(.hidden)

                    List {
                        ForEach(links) { link in
                            NavigationLink {
                                switch link.type {
                                    case .history:
                                        ProblemHistoryView()
                                    case .stats:
                                        StyledNavigationBar {
                                            UserStatsView(stats: stats)
                                                .scrollContentBackground(.hidden)
                                        }
                                    case .saved:
                                        SavedProblemsView()
                                    case .settings:
                                        UserSettingsView()
                                }
                            } label: {
                                Text(link.name)
                            }
                            .disabled(!authenticationService.state.isAuthorized())
                        }
                    }
                    .frame(height: 20 + (48 * CGFloat(links.count)))
                    .scrollDisabled(true)
                    .scrollContentBackground(.hidden)
                    
                    if authenticationService.state.isAuthorized() {
                        List {
                            Button {
                                authenticationService.logout()
                                isDone.toggle()
                            } label: {
                                HStack {
                                    Text("Logout")
                                    Spacer()
                                    Image(systemName: "chevron.forward")
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                        .frame(height: 20  + 48 + 20)
                        .scrollDisabled(true)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .background(Color.primaryBackground)
        }
        .task {
            do {
                let response = try await webClient.codeHelpClient.getUserStatistics()
                await MainActor.run {
                    stats = response.toStat()
                }
            } catch {
                print(error)
            }
        }
    }
}

struct UserStatsView: View {
    let stats: [Stat]
    
    var body: some View {
        List {
            ForEach(stats) { stat in
                HStack {
                    Text(stat.name)
                    Spacer()
                    Text(stat.value)
                }
            }
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        AttachEnvironmentObjects {
            ProfileView()
        }
    }
}
