//
//  TokenManager.swift
//
//
//  Created by Ramanathan on 06/08/24.
//

import Foundation
import Combine
import AuthUI

class TokenManager {
    static let shared = TokenManager()
    private init() {}
    
    var accessToken: String? {
        // Retrieve access token from secure storage (e.g., Keychain)
        if let retrievedToken = KeychainHelper.shared.retrieveAccessToken(forKey: Keys.accessTokenKey) {
            debugPrint("Retrieved access token: \(retrievedToken)")
            return retrievedToken
        } else {
            debugPrint("Failed to retrieve access token")
        }
        return nil
    }
    
    var refreshToken: String? {
        return AuthUI.TokenManager.shared.fetchRefreshToken(accessToken)
    }
    
    func handleRefreshToken() -> AnyPublisher<String, CustomError> {
        // Implement the refresh token request here
        // Assume you have a method for creating the refresh token request
        guard let request = RequestBuilder.buildRefreshTokenRequest() else {
            return Fail(error: CustomError.networkRequestBuildFailure).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                let tokenResponse = try JSONDecoder().decode(AuthenticationResponse.self, from: data)
                // Save new tokens to secure storage
                let _ = AuthUI.KeychainHelper.storeUserAuthenticationResponse(model: tokenResponse)
                self.storeAccessToken(tokenResponse.accessToken ?? "")
                return tokenResponse.accessToken ?? ""
            }
            .mapError { error in
                CustomError.networkError(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
    func storeAccessToken(_ accessToken: String) {
        // Store access token
        let isSuccess = KeychainHelper.shared.storeAccessToken(accessToken, forKey: Keys.accessTokenKey)
        debugPrint("Store access token: \(isSuccess)")
    }
}
