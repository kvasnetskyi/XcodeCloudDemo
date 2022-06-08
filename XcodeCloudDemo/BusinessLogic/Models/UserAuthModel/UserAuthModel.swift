//
//  UserAuthModel.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import Foundation

protocol UserAuthModel {
    var idToken: String { get }
    var refreshToken: String { get }
}
