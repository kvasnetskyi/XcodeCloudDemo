//
//  UserService.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import Foundation
import KeychainAccess

protocol UserService: AnyObject {
    var isAuthorized: Bool { get }
    var token: String? { get }
    var refreshToken: String? { get }
    
    func save(_ model: UserAuthModel)
    func clear()
}
