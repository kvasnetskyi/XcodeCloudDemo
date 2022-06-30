//
//  AuthServiceStub.swift
//  XcodeCloudDemoTests
//
//  Created by Artem Kvasnetskyi on 15.06.2022.
//

import Foundation
import Combine
import CombineNetworking

@testable import XcodeCloudDemo

final class AuthServiceStub {
    // MARK: - Enum
    enum Result {
        case value
        case error
        
        func get() -> AnyPublisher<UserAuthModel, CNError> {
            switch self {
            case .value:
                return Just(UserModel(idToken: .empty, refreshToken: .empty))
                    .setFailureType(to: CNError.self)
                    .eraseToAnyPublisher()
                
            case .error:
                return Fail(error: CNError.unspecifiedError)
                    .eraseToAnyPublisher()
            }
        }
    }
    
    // MARK: - Properties
    var result: Result
    
    // MARK: - Init
    init(return result: Result) {
        self.result = result
    }
}

// MARK: - AuthService
extension AuthServiceStub: AuthService {
    func login(_ model: UserAuthRequestModel) -> AnyPublisher<UserAuthModel, CNError> {
        result.get()
    }
    
    func registration(_ model: UserAuthRequestModel) -> AnyPublisher<UserAuthModel, CNError> {
        result.get()
    }
}
