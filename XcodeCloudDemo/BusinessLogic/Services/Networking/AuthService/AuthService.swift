//
//  AuthService.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import Combine
import CombineNetworking

protocol AuthService {
    func login(_ model: UserAuthRequestModel) -> AnyPublisher<UserAuthModel, CNError>
    func registration(_ model: UserAuthRequestModel) -> AnyPublisher<UserAuthModel, CNError>
}
