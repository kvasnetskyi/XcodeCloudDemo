//
//  SignUpViewModel.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import Foundation
import Combine

final class SignUpViewModel: BaseViewModel {
    // MARK: - Internal Properties
    @Published var email: String = .empty
    @Published var password: String = .empty
    @Published var confirmPassword: String = .empty
    @Published private(set) var isInputValid: Bool = false
    
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    
    // MARK: - Private Properties
    private let transitionSubject = PassthroughSubject<SignUpTransition, Never>()
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

// MARK: - Internal Methods
extension SignUpViewModel {
    func signUpUser() {
        let model = UserAuthRequestModel(email: email, password: password)
        isLoadingSubject.send(true)
        
        authService.registration(model)
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
private extension SignUpViewModel {
    func binding() {
        $email.combineLatest($password, $confirmPassword)
            .map { [unowned self] email, password, confirmPassword -> Bool in
                let isValidEmail = validator.isValidEmail(email)
                let isValidPassword = validator.isValidPassword(password)
                let isPasswordsAreEqual = password == confirmPassword
                
                return isValidEmail && isValidPassword && isPasswordsAreEqual
            }
            .sink { [unowned self] in isInputValid = $0 }
            .store(in: &subscriptions)
    }
}
