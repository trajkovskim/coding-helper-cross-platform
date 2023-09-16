//
//  AuthenticationHelper.swift
//  
//
//  Created by Vangel Trajkovski on 10.9.23.
//

import Foundation
import AppAuth


public class AuthorizationResponseHandler: ResponseHandler<OIDAuthorizationResponse> {
}

public class EndSessionResponseHandler: ResponseHandler<OIDEndSessionResponse> {
}

public class ResponseHandler<Response> {
    
    var storedContinuation: CheckedContinuation<Response?, Error>?
    
    func waitForCallback() async throws -> Response? {
        try await withCheckedThrowingContinuation { continuation in
            self.storedContinuation = continuation
        }
    }
    
    func callback(response: Response?, error: Error?) {
        if error != nil {
            self.storedContinuation?.resume(throwing: error!)
            return
        } else {
            storedContinuation?.resume(returning: response)
            return
        }
    }
}


class JwtDecored {
    
    public  func decode(jwtToken jwt: String) -> [String: Any] {
        let segments = jwt.components(separatedBy: ".")
        return decodeJWTPart(segments[1]) ?? [:]
    }
    
    private func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 = base64 + padding
        }
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
    
    private func decodeJWTPart(_ value: String) -> [String: Any]? {
        guard let bodyData = base64UrlDecode(value),
              let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
            return nil
        }
        
        return payload
    }
}
