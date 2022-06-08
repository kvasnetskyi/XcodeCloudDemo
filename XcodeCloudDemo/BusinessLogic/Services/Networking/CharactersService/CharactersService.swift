//
//  CharactersService.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import Foundation
import CombineNetworking
import Combine

protocol CharactersService {
    func getCharacters() -> AnyPublisher<[CharacterModel], CNError>
}
