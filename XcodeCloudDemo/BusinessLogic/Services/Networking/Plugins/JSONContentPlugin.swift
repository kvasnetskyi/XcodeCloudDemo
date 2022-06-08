//
//  JSONContentPlugin.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import Foundation
import CombineNetworking

struct JSONContentPlugin: CNPlugin {
    func modifyRequest(_ request: inout URLRequest) {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}
