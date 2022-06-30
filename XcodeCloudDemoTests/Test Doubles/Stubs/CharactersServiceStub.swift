//
//  CharactersServiceStub.swift
//  XcodeCloudDemoTests
//
//  Created by Artem Kvasnetskyi on 26.06.2022.
//

import Foundation
import Combine
import CombineNetworking

@testable import XcodeCloudDemo

class CharactersServiceStub {
    // MARK: - Enum
    enum Result {
        case value
        case error
        
        func get() -> AnyPublisher<[CharacterModel], CNError> {
            switch self {
            case .value:
                let model = CharacterModel(
                    gender: .empty, name: .empty,
                    image: .init(string: "https://sut")!,
                    species: .empty, status: .empty
                )
                
                return Just([model])
                    .setFailureType(to: CNError.self)
                    .eraseToAnyPublisher()
                
            case .error:
                return Fail(error: CNError.unspecifiedError)
                    .eraseToAnyPublisher()
            }
        }
    }
    
    // MARK: - Properties
    var result: Result
    
    private(set) var numberOfCalls = Int.zero
    
    
    // MARK: - Init
    init(return result: Result) {
        self.result = result
    }
}

// MARK: - CharactersService
extension CharactersServiceStub: CharactersService {
    func getCharacters() -> AnyPublisher<[CharacterModel], CNError> {
        numberOfCalls += 1
        
        return result.get()
    }
}
