//
//  Config.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 30.8.23.
//

import Foundation
import Authentication

public struct Config {
    enum Keys {
        static let issuerUrl = "ISSUER_URL"
        static let redirectUrl = "REDIRECT_URL"
        static let clientId = "CLIENT_ID"
    }
    
    static let issuer: URL = { return Self.getUrl(forKey: Keys.issuerUrl) }()
    static let redirectUrl: URL = { return Self.getUrl(forKey: Keys.redirectUrl) }()
    static let clientId: String = { return Self.getString(forKey: Keys.clientId) }()
    
    
    private static func getUrl(forKey key: String) -> URL {
        let property = getString(forKey: key)
        return URL(string: property)!
    }
    
    
    private static func getString(forKey key: String) -> String {
        guard let property = Bundle.main.object(forInfoDictionaryKey: key) as? String
        else {
            fatalError("\(key) not found")
        }
        
        return property
    }
}


