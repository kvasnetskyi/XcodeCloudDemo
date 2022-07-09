//
//  UserServiceFake.swift
//  XcodeCloudDemoTests
//
//  Created by Artem Kvasnetskyi on 15.06.2022.
//

import Foundation

@testable import XcodeCloudDemo

final class UserServiceFake: UserService {
    // MARK: - Internal Properties
    var isAuthorized: Bool {
        storage[.token] != nil
    }
    
    var token: String? {
        storage[.token]
    }
    
    var refreshToken: String? {
        storage[.refreshToken]
    }
    
    // MARK: - Private Properties
    private var storage = [Keys: String]()
    
    // MARK: - Methods
    func save(_ model: UserAuthModel) {
        storage[.token] = model.idToken
        storage[.refreshToken] = model.refreshToken
    }
    
    func clear() {
        storage[.token] = nil
        storage[.refreshToken] = nil
    }
}

// MARK: - Models
private extension UserServiceFake {
    enum Keys: String {
        case token
        case refreshToken
    }
}
