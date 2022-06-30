//
//  AuthSelectViewModel.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import Combine

final class AuthSelectViewModel: BaseViewModel {
    // MARK: - Internal Properties
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    
    // MARK: - Private Properties
    private let transitionSubject = PassthroughSubject<AuthSelectTransition, Never>()
}

// MARK: - Internal Methods
extension AuthSelectViewModel {
    func showSignIn() {
        transitionSubject.send(.signIn)
    }
    
    func showSignUp() {
        transitionSubject.send(.signUp)
    }
}
