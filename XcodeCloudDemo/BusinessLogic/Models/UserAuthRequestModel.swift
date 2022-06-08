//
//  UserAuthRequestModel.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import Foundation

struct UserAuthRequestModel: Encodable {
    let email: String
    let password: String
}
