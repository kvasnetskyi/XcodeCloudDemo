//
//  AuthServiceImpl.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import Foundation
import Combine
import CombineNetworking

struct AuthServiceImpl {
    private let provider: CNProvider<AuthAPIRequestBuilder, NetworkingHandler>
    
    init(_ provider: CNProvider<AuthAPIRequestBuilder, NetworkingHandler>) {
        self.provider = provider
    }
}

// MARK: - AuthService
extension AuthServiceImpl: AuthService {
    func login(_ model: UserAuthRequestModel) -> AnyPublisher<UserAuthModel, CNError> {
        provider.perform(
            .login(model: model),
            decodableType: UserModel.self
        )
    }
    
    func registration(_ model: UserAuthRequestModel) -> AnyPublisher<UserAuthModel, CNError> {
        provider.perform(
            .registration(model: model),
            decodableType: UserModel.self
        )
    }
}
