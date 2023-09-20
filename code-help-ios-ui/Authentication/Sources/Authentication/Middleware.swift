//
//  Middleware.swift
//  
//
//  Created by Vangel Trajkovski on 10.9.23.
//

import Foundation
import OpenAPIRuntime

public class AnyResponseHandler: ResponseHandler<Request> {
}

public struct AuthenticationMiddleware: ClientMiddleware {
    private let authenticationService: AuthenticationService
    
    public init(_ authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    public func intercept(
        _ request: Request,
        baseURL: URL,
        operationID: String,
        next: (Request, URL) async throws -> Response
    ) async throws -> Response {
        let newRequest = try await self.appendAuthorizationHeader(request) ?? request
        return try await next(newRequest, baseURL)
    }
    
    private func appendAuthorizationHeader(_ request: Request) async throws -> Request? {
        guard let authenticationState = authenticationService.state.getState()  else {
            return nil
        }
        
        let handler = AnyResponseHandler()
        authenticationState.performAction { accessToken, idToken, error in
            guard let accessToken = accessToken else {
                handler.callback(response: request, error: nil)
                return
            }
            
            var request = request
            request.headerFields.append(.init(
                name: "Authorization", value: "Bearer \(accessToken)"
            ))
            handler.callback(response: request, error: nil)
        }
        
        return try await handler.waitForCallback()
    }
}
