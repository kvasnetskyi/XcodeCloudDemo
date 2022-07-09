//
//  CharactersServiceMock.swift
//  XcodeCloudDemoTests
//
//  Created by Artem Kvasnetskyi on 26.06.2022.
//

import Foundation
import Combine
import CombineNetworking

@testable import XcodeCloudDemo

class CharactersServiceMock {
    // MARK: - Properties
    private var output: AnyPublisher<[CharacterModel], CNError>
    
    private(set) var numberOfCalls = Int.zero
    
    // MARK: - Init
    init(return output: AnyPublisher<[CharacterModel], CNError>) {
        self.output = output
    }
}

// MARK: - CharactersService
extension CharactersServiceMock: CharactersService {
    func getCharacters() -> AnyPublisher<[CharacterModel], CNError> {
        numberOfCalls += 1
        
        return output
    }
}
