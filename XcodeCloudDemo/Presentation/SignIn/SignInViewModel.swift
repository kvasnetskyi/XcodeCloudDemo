//
//  SignInViewModel.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import Foundation
import Combine

final class SignInViewModel: BaseViewModel {
    // MARK: - Internal Properties
    @Published var email: String = .empty
    @Published var password: String = .empty
    @Published private(set) var isInputValid: Bool = false
    
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    
    // MARK: - Private Properties
    private let transitionSubject = PassthroughSubject<SignInTransition, Never>()
    
    private let authService: AuthService
    private let userService: UserService
    private let validator: Validator

    // MARK: - Init
    init(
        authService: AuthService,
        userService: UserService,
        validator: Validator
    ) {
        self.authService = authService
        self.userService = userService
        self.validator = validator
        
        super.init()
    }
    
    override func onViewDidLoad() {
        super.onViewDidLoad()
        
        binding()
    }
}

// MARK: - Inernal Methods
extension SignInViewModel {
    func signInUser() {
        let model = UserAuthRequestModel(email: email, password: password)
        isLoadingSubject.send(true)
        
        authService.login(model)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoadingSubject.send(false)
                
                guard case let .failure(error) = completion else {
                    return
                }
                
                self?.errorSubject.send(error)
                
            } receiveValue: { [weak self] response in
                self?.userService.save(response)
                self?.transitionSubject.send(.success)
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Private Methods
private extension SignInViewModel {
    func binding() {
        $email.combineLatest($password)
            .map { [unowned self] email, password -> Bool in
                let isEmailValid = validator.isValidEmail(email)
                let isPasswordValid = validator.isValidPassword(password)
                
                return isEmailValid && isPasswordValid
            }
            .sink { [unowned self] in isInputValid = $0 }
            .store(in: &subscriptions)
    }
}
