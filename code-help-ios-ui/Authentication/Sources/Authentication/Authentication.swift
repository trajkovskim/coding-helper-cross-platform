import Foundation
import AppAuth
import OpenAPIRuntime
import Combine

public protocol AuthenticationServiceProtocol {
    var state: InternalAuthStateProtocol { get }
    var tokenState: TokenData? { get }
    
    func login()
    func logout()
    func setOnChange(_ onChange: @escaping () -> Void)
}

extension AuthenticationServiceProtocol {
    public func setOnChange(_ onChange: @escaping () -> Void) { }
}

public class AuthenticationService: AuthenticationServiceProtocol, ObservableObject {
    @Published private var flow: AuthenticationServiceProtocol
    
    public var state: InternalAuthStateProtocol {
        flow.state
    }
    
    public var tokenState: TokenData? {
        flow.tokenState
    }
    
    public func login() {
        flow.login()
        self.objectWillChange.send()
    }
    
    public func logout() {
        flow.logout()
        self.objectWillChange.send()
    }
    
    
    public init(_ config: AuthenticationConfig) {
        self.flow = AuthenticationServiceFlow(config)
        self.flow.setOnChange(self.objectWillChange.send)
    }
    
    init() {
        self.flow = StubAuthenticationService()
    }
    
    static func stub() -> AuthenticationService {
        .init()
    }
}


public class InternalAuthState: InternalAuthStateProtocol, ObservableObject {
    @Published private var state: OIDAuthState? {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    var accessToken: String? { state?.lastTokenResponse?.accessToken }
    var idToken: String? { state?.lastTokenResponse?.idToken }
    
    public func isAuthorized() -> Bool {
        state?.isAuthorized ?? false
    }
    
    public func getState() -> OIDAuthState? {
        state
    }
    
    func setState(_ newState: OIDAuthState?) {
        self.state = newState
        self.objectWillChange.send()
    }
    
    func update(withAuthResponse authResponse: OIDAuthorizationResponse?, withTokenResponse tokenResponse: OIDTokenResponse?, error: Error?) {
        if let authState = self.state {
            authState.update(with: tokenResponse, error: nil)
            self.objectWillChange.send()
        } else if let authResponse = authResponse {
            self.setState(.init(authorizationResponse: authResponse, tokenResponse: tokenResponse))
            self.objectWillChange.send()
        }
    }
}

public class AuthenticationState: ObservableObject {
    @Published private var authState = InternalAuthState()
    
    private var jwtDecoder = JwtDecored()
    
    public init() {
    }
    
    public func get() -> InternalAuthState {
        return authState
    }
    
    public func getTokenData() -> TokenData? {
        guard let accessToken = authState.accessToken else { return nil }
        let data = jwtDecoder.decode(jwtToken: accessToken)
        return TokenData(from: data)
    }
    
    func set(authState state: OIDAuthState?) {
        self.objectWillChange.send()
        self.authState.setState(state)
    }
    
    func update(withAuthResponse authResponse: OIDAuthorizationResponse?, withTokenResponse tokenResponse: OIDTokenResponse?, error: Error?) {
        self.objectWillChange.send()
        self.authState.update(withAuthResponse: authResponse, withTokenResponse: tokenResponse, error: error)
    }
    
    func clear() {
        self.objectWillChange.send()
        self.authState.setState(OIDAuthState(authorizationResponse: nil, tokenResponse: nil, registrationResponse: nil))
    }
}


public class AuthenticationServiceFlow: ObservableObject {
    
    private let authenticationConfig: AuthenticationConfig

    @Published private var authenticationState: AuthenticationState = AuthenticationState()
    private var authorizationFlow: OIDExternalUserAgentSession?
    private var configuration: OIDServiceConfiguration?
    
    public var stateChange: (() -> Void)?
    
    public init(_ config: AuthenticationConfig) {
        self.authenticationConfig = config
    }
    
    private func fetchConfiguration() async throws -> OIDServiceConfiguration? {
        return try await withCheckedThrowingContinuation { continuation in
            if configuration != nil {
                continuation.resume(returning: configuration)
                return
            }
            
            OIDAuthorizationService.discoverConfiguration(forIssuer: authenticationConfig.issuer) { configuration, error in
                if let configuration = configuration {
                    self.configuration = configuration
                    continuation.resume(returning: configuration)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    private func performAuthorization(configuration: OIDServiceConfiguration, clientId: String, viewController: UIViewController, handler: AuthorizationResponseHandler) {
        let request = OIDAuthorizationRequest(
            configuration: configuration,
            clientId: clientId,
            clientSecret: nil,
            scopes: [OIDScopeOpenID, OIDScopeProfile],
            redirectURL: authenticationConfig.redirectUrl,
            responseType: OIDResponseTypeCode,
            additionalParameters: nil
        )
        
        self.authorizationFlow = OIDAuthorizationService.present(request, presenting: viewController, callback: handler.callback)
    }
    
    
    
    private func performEndSession(configuration: OIDServiceConfiguration, clientId: String, viewController: UIViewController, handler: EndSessionResponseHandler) {
        guard let tokenId = self.authenticationState.get().idToken else { return }
        let request = OIDEndSessionRequest(
            configuration: configuration,
            idTokenHint: tokenId,
            postLogoutRedirectURL: authenticationConfig.redirectUrl,
            additionalParameters: nil
        )
        
        let userAgent = OIDExternalUserAgentIOS(presenting: viewController)
        self.authorizationFlow = OIDAuthorizationService.present(request, externalUserAgent: userAgent!, callback: handler.callback)
    }
    
    private func performTokenRequest(with response: OIDAuthorizationResponse?) async throws -> OIDTokenResponse? {
        return try await withCheckedThrowingContinuation { continuation in
            if let response = response {
                let request = response.tokenExchangeRequest(withAdditionalParameters: [:])
                OIDAuthorizationService.perform(request!, originalAuthorizationResponse: response) { tokenResponse, error in
                    if let tokenResponse = tokenResponse {
                        continuation.resume(returning: tokenResponse)
                    } else if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: nil)
                    }
                }
            }
            else {
                return continuation.resume(returning: nil)
            }
        }
    }
    
    
    private func clearAuthorizationFlow() {
        self.authorizationFlow = nil
    }
    
    private func getViewController() -> UIViewController {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scene!.keyWindow!.rootViewController!
    }
}

extension AuthenticationServiceFlow: AuthenticationServiceProtocol {
    public func setOnChange(_ onChange: @escaping () -> Void) {
        self.stateChange = onChange
    }
    
    public var state: InternalAuthStateProtocol {
        get { authenticationState.get() }
    }
    
    public var tokenState: TokenData? {
        get { authenticationState.getTokenData() }
    }
    
    public func login() {
        Task {
            do {
                let configuration = try await self.fetchConfiguration()!
                
                let authHandler = AuthorizationResponseHandler()
                await MainActor.run {
                    self.performAuthorization(
                        configuration: configuration,
                        clientId: authenticationConfig.clientId,
                        viewController: getViewController(),
                        handler: authHandler
                    )
                }
                
                let response = try await authHandler.waitForCallback()
                let tokenResponse = try await self.performTokenRequest(with: response)
                
                await MainActor.run {
                    self.objectWillChange.send()
                    self.authenticationState.update(withAuthResponse: response, withTokenResponse: tokenResponse, error: nil)
                    self.stateChange?()
                }
                
                clearAuthorizationFlow()
            }
            catch {
                print("[ERROR] Login failed")
            }
        }
    }
    
    public func logout() {
        Task {
            do {
                let configuration = try await self.fetchConfiguration()!
                
                let authHandler = EndSessionResponseHandler()
                await MainActor.run {
                    self.performEndSession(
                        configuration: configuration,
                        clientId: authenticationConfig.clientId,
                        viewController:getViewController(),
                        handler: authHandler
                    )
                }
                
                let _ = try await authHandler.waitForCallback()
                await MainActor.run {
                    self.objectWillChange.send()
                    self.authenticationState.clear()
                    self.stateChange?()
                }
                
                clearAuthorizationFlow()
            }
            catch {
                print("[ERROR] Logout failed")
            }
        }
    }
}

extension AuthenticationServiceFlow {
    public func performAuthorization(configuration: OIDServiceConfiguration, clientId: String, viewController: UIViewController) {
        
        let request = OIDAuthorizationRequest(
            configuration: configuration,
            clientId: clientId,
            clientSecret: nil,
            scopes: [OIDScopeOpenID, OIDScopeProfile],
            redirectURL: authenticationConfig.redirectUrl,
            responseType: OIDResponseTypeCode,
            additionalParameters: nil
        )
        
        self.authorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: viewController) { authState, error in
            if let authState = authState {
                self.authenticationState.set(authState: authState)
            } else {
                self.authenticationState.set(authState: nil)
            }
        }
    }
    
    public func handleOpen(url: URL) {
        if let authorizationFlow = authorizationFlow,
           authorizationFlow.resumeExternalUserAgentFlow(with: url) {
            self.clearAuthorizationFlow()
            return;
        }
    }
}

