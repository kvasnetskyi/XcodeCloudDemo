//
//  CharactersAPIRequestBuilder.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import Foundation
import CombineNetworking

enum CharactersAPIRequestBuilder: CNRequestBuilder {
    case getCharacters
    
    var path: String {
        switch self {
        case .getCharacters:
            return "/results.json"
        }
    }
    
    var query: QueryItems? { nil }
    var body: Data? { nil }
    
    var method: HTTPMethod {
        switch self {
        case .getCharacters:
            return .get
        }
    }
}
