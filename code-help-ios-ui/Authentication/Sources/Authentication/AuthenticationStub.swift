//
//  AuthenticationStub.swift
//  
//
//  Created by Vangel Trajkovski on 10.9.23.
//

import Foundation
import AppAuth

public class AuthenticationStub {
    public static func create() -> AuthenticationService {
        AuthenticationService.stub()
    }
}

class StubInternalAuthState: InternalAuthStateProtocol, ObservableObject {
    @Published private var authenticated: Bool
    
    init() {
        self.authenticated = false
    }
    
    func isAuthorized() -> Bool {
        self.authenticated
    }
    
    func setState(_ value: Bool) {
        self.objectWillChange.send()
        self.authenticated = value
    }
    
    public func getState() -> OIDAuthState? {
        nil
    }
    
    func getTokenData() -> TokenData? {
        if !self.authenticated {
            return nil
        }
        
        return .init(username: "vangel")
    }
}

class StubAuthenticationService: AuthenticationServiceProtocol, ObservableObject {
    private var authenticationState = StubInternalAuthState()
    
    public var state: InternalAuthStateProtocol {
        authenticationState
    }
    
    public var tokenState: TokenData? {
        authenticationState.getTokenData()
    }
    
    public func login() {
        authenticationState.setState(true)
    }
    
    public func logout() {
        authenticationState.setState(false)
    }
}
