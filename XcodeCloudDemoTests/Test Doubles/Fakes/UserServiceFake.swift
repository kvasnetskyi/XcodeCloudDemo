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
        self[.token] != nil
    }
    
    var token: String? {
        self[.token]
    }
    
    var refreshToken: String? {
        self[.refreshToken]
    }
    
    // MARK: - Private Properties
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Methods
    func save(_ model: UserAuthModel) {
        self[.token] = model.idToken
        self[.refreshToken] = model.refreshToken
    }
    
    func clear() {
        self[.token] = nil
        self[.refreshToken] = nil
    }
}

// MARK: - Private Methods
private extension UserServiceFake {
    subscript(key: Keys) -> String? {
        get {
            userDefaults.string(forKey: key.rawValue)
        } set {
            userDefaults.setValue(newValue, forKey: key.rawValue)
        }
    }
}

// MARK: - Models
private extension UserServiceFake {
    enum Keys: String {
        case token
        case refreshToken
    }
}
