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
    // MARK: - Properties
    private var output: AnyPublisher<UserAuthModel, CNError>
    
    // MARK: - Init
    init(return output: AnyPublisher<UserAuthModel, CNError>) {
        self.output = output
    }
}

// MARK: - AuthService
extension AuthServiceStub: AuthService {
    func login(_ model: UserAuthRequestModel) -> AnyPublisher<UserAuthModel, CNError> {
        output
    }
    
    func registration(_ model: UserAuthRequestModel) -> AnyPublisher<UserAuthModel, CNError> {
        output
    }
}
