//
//  SignUpViewModelBuilder.swift
//  XcodeCloudDemoTests
//
//  Created by Artem Kvasnetskyi on 09.07.2022.
//

import Foundation

@testable import XcodeCloudDemo

final class SignUpViewModelBuilder: BaseAuthenticationViewModelBuilder {
    // MARK: - Properties
    private var confirmPassword: String?
}

// MARK: - Methods
extension SignUpViewModelBuilder {
    func with(confirmPassword: String) -> Self {
        self.confirmPassword = confirmPassword
        
        return self
    }
    
    func makeConfirmPasswordValid() -> Self {
        self.confirmPassword = "12345aA!"
        
        return self
    }
    
    func makeConfirmPasswordNotValid() -> Self {
        self.confirmPassword = "Not valid confirm password"
        
        return self
    }
    
    func makeConfirmPasswordNotEqualToPassword() -> Self {
        self.confirmPassword = "12345aA!!"
        
        return self
    }
    
    func build() -> SignUpViewModel {
        let viewModel = SignUpViewModel(
            authService: authService,
            userService: userService,
            validator: validator
        )
        
        if let email = email {
            viewModel.email = email
        }
        
        if let password = password {
            viewModel.password = password
        }
        
        if let confirmPassword = confirmPassword {
            viewModel.confirmPassword = confirmPassword
        }
        
        viewState.setViewState(viewModel)
        
        return viewModel
    }
}
