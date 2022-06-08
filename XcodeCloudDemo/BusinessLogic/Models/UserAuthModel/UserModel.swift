//
//  UserModel.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import Foundation

struct UserModel: Decodable, UserAuthModel {
    let idToken: String
    let refreshToken: String
}
