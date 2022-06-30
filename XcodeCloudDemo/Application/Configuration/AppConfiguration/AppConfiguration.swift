//
//  AppConfiguration.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import Foundation

protocol AppConfiguration {
    var bundleId: String { get }
    var environment: AppEnvironment { get }
}
