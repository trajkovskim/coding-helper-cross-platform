//
//  Config+Authentication.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 30.8.23.
//

import Foundation
import Authentication

extension Config {

    static func getAuthenticationConfig() -> AuthenticationConfig {
        .init(issuer: Self.issuer, redirectUrl: Self.redirectUrl, clientId: Self.clientId)
    }
}
