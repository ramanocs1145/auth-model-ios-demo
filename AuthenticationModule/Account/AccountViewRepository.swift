//
//  AccountViewRepository.swift
//  AuthenticationModule
//
//  Created by Ramanathan on 07/08/24.
//

import Foundation
import Combine

public protocol FetchUserProfileSeviceDelegate {
    func fetchUserProfileRequest(accessToken: String?, completionHandler: @escaping (Result<UserProfileDataModel, CustomError>) -> Void)
}

public final class FetchUserProfileService: FetchUserProfileSeviceDelegate {
    // MARK: - Variables
    private var cancellables = Set<AnyCancellable>()
    private let network: NetworkFactoryType
    
    // MARK: - Methods
    public init(network: NetworkFactoryType) {
        self.network = network
    }
    
    public func fetchUserProfileRequest(accessToken: String?, completionHandler: @escaping (Result<UserProfileDataModel, CustomError>) -> Void) {
        let publisher: AnyPublisher<UserProfileDataModel, CustomError> = network.fetch(
            requestConfig: FetchUserProfileRequestConfig.details(apiVersion: API.apiVersion, bearerToken: accessToken, queryParams: nil, multipartData: nil),
            shouldCache: false,
            endpointUrl: API.baseURL
        )
        publisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    debugPrint("Request completed successfully.")
                case .failure(let error):
                    debugPrint("Request failed with error: \(error)")
                    completionHandler(.failure(error))
                }
            }, receiveValue: { (response: UserProfileDataModel) in
                debugPrint("Received response: \(response)")
                completionHandler(.success(response))
            })
            .store(in: &cancellables)
    }
}

enum FetchUserProfileRequestConfig {
    case details(apiVersion: String, bearerToken: String?, queryParams: [String: String]?, multipartData: MultipartFormData?)
}

extension FetchUserProfileRequestConfig: RequestConfig {
    var baseURL: URL {
        return URL(string: API.baseURL)! // Set your base URL here
    }
    
    var path: String {
        switch self {
        case .details(let apiVersion, _, _, _):
            return apiVersion + "/profile"
        }
    }
    
    var method: HTTPMethod { .get }
    
    var parameters: [String: Any]? {
        switch self {
        case .details(_, _, _, _):
            return nil
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .details(_, let bearerToken, _, _):
            var headers = ["Content-Type": "application/json"]
            if let token = bearerToken {
                headers["Authorization"] = "Bearer \(token)"
            }
            return headers
        }
    }
    
    var bearerToken: String? {
        switch self {
        case .details(_, let token, _, _):
            return token
        }
    }
    
    var queryParams: [String: String]? {
        switch self {
        case .details(_, _, let queryParams, _):
            return queryParams
        }
    }
    
    var multipartData: MultipartFormData? {
        switch self {
        case .details(_, _, _, let multipartData):
            return multipartData
        }
    }
}
