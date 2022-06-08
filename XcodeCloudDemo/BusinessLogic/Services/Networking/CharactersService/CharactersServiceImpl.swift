//
//  CharactersServiceImpl.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import Foundation
import Combine
import CombineNetworking

struct CharactersServiceImpl {
    private let provider: CNProvider<CharactersAPIRequestBuilder, NetworkingHandler>
    
    init(_ provider: CNProvider<CharactersAPIRequestBuilder, NetworkingHandler>) {
        self.provider = provider
    }
}

// MARK: - CharactersService
extension CharactersServiceImpl: CharactersService {
    func getCharacters() -> AnyPublisher<[CharacterModel], CNError> {
        provider.perform(.getCharacters)
            .eraseToAnyPublisher()
    }
}
