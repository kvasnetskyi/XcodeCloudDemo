//
//  AppEnvironment.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import Foundation

enum AppEnvironment: String {
    case dev
    case stg
    case prod

    var storageBaseURL: URL {
        switch self {
        case .dev, .stg, .prod:
            return URL(string: "https://rickandmortydemo-default-rtdb.europe-west1.firebasedatabase.app")!
        }
    }
    
    var authBaseURL: URL {
        switch self {
        case .dev, .stg, .prod:
            return URL(string: "https://identitytoolkit.googleapis.com")!
        }
    }
    
    var tokenBaseURL: URL {
        switch self {
        case .dev, .stg, .prod:
            return URL(string: "https://securetoken.googleapis.com")!
        }
    }
    
    var authAPIKey: String {
        switch self {
        case .dev, .stg, .prod:
            return "AIzaSyCa09W5VQZtpWaVT0ua0mNbhvpM6tibLJk"
        }
    }
}
