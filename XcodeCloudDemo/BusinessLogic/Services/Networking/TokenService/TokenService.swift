//
//  TokenService.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import Combine
import CombineNetworking

protocol TokenService {
    func refreshToken(_ model: TokenRequestModel) -> AnyPublisher<UserAuthModel, CNError>
}
