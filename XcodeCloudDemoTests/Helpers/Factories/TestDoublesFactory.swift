//
//  TestDoublesFactory.swift
//  XcodeCloudDemoTests
//
//  Created by Artem Kvasnetskyi on 09.07.2022.
//

import Foundation
import Combine
import CombineNetworking

@testable import XcodeCloudDemo

struct TestDoublesFactory {
    static func getUserServiceFake() -> UserServiceFake {
        UserServiceFake()
    }
    
    static func getCharactersServiceMock(result: Result) -> CharactersServiceMock {
        let output: AnyPublisher<[CharacterModel], CNError>
        
        switch result {
        case .success:
            let model = CharacterModel(
                gender: .empty, name: .empty,
                image: .init(string: "https://dummy")!,
                species: .empty, status: .empty
            )
            
            output = Just([model])
                .setFailureType(to: CNError.self)
                .eraseToAnyPublisher()
            
        case .failure:
            output = Fail(error: CNError.unspecifiedError)
                .eraseToAnyPublisher()
        }
        
        return CharactersServiceMock(return: output)
    }
    
    static func getAuthServiceStub(result: Result) -> AuthServiceStub {
        let output: AnyPublisher<UserAuthModel, CNError>
        
        switch result {
        case .success:
            output = Just(UserModel(idToken: .empty, refreshToken: .empty))
                .setFailureType(to: CNError.self)
                .eraseToAnyPublisher()
            
        case .failure:
            output = Fail(error: CNError.unspecifiedError)
                .eraseToAnyPublisher()
        }
        
        return AuthServiceStub(return: output)
    }
}

// MARK: - Models
extension TestDoublesFactory {
    enum Result {
        case success
        case failure
    }
}
