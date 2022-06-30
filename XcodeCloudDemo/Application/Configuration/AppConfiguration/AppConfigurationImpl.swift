//
//  AppConfigurationImpl.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetskyi on 15.06.2022.
//

import Foundation

final class AppConfigurationImpl: AppConfiguration {
    let bundleId: String
    let environment: AppEnvironment
    
    init(bundle: Bundle = .main) {
        guard
            let bundleId = bundle.bundleIdentifier,
            let infoDict = bundle.infoDictionary,
            let environmentValue = infoDict[Key.Environment] as? String,
            let environment = AppEnvironment(rawValue: environmentValue)
        else {
            fatalError("config file error")
        }
        
        self.bundleId = bundleId
        self.environment = environment

        debugPrint(environment)
        debugPrint(bundleId)
    }
}

fileprivate enum Key {
    static let Environment: String = "APP_ENVIRONMENT"
}
