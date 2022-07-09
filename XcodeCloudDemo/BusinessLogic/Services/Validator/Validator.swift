//
//  Validator.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetskyi on 15.06.2022.
//

import Foundation

protocol Validator {
    func isValidEmail(_ email: String) -> Bool
    func isValidPassword(_ password: String) -> Bool
}
