//
//  Common.swift
//  
//
//  Created by Vangel Trajkovski on 10.9.23.
//

import Foundation
import AppAuth

public struct AuthenticationConfig {
    let issuer: URL
    let redirectUrl: URL
    let clientId: String
    
    public init(issuer: URL, redirectUrl: URL, clientId: String) {
        self.issuer = issuer
        self.redirectUrl = redirectUrl
        self.clientId = clientId
    }
}


public protocol InternalAuthStateProtocol {
    var isAuthorized: Bool { get }
    
    func getState() -> OIDAuthState?
}

public class TokenData {
    private enum Keys {
        static let preferredUsername = "preferred_username"
    }
    
    public let username: String
    
    init(from data: [String: Any]) {
        self.username = data[Keys.preferredUsername] as! String
    }
    
    init(username: String) {
        self.username = username
    }
}
