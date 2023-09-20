//
//  code_help_ios_uiApp.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 20.8.23.
//

import SwiftUI
import Authentication

@main
struct CodeHelpApp: App {
    
    var body: some Scene {
        WindowGroup {
            AttachEnvironmentObjects {
                ContentView()
            }
            .background(.primaryBackground)
        }
    }
}



