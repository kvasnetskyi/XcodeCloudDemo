//
//  BaseAuthenticationViewModelBuilderInterface.swift
//  XcodeCloudDemoTests
//
//  Created by Artem Kvasnetskyi on 09.07.2022.
//

import Foundation

@testable import XcodeCloudDemo

class BaseAuthenticationViewModelBuilder: BaseViewModelBuilder {
    // MARK: - Properties
    private(set) var authService: AuthService = TestDoublesFactory.getAuthServiceStub(result: .success)
    private(set) var userService: UserService = TestDoublesFactory.getUserServiceFake()
    private(set) var validator: Validator = ValidatorImpl()
    
    private(set) var email: String?
    private(set) var password: String?
}

// MARK: - Methods
extension BaseAuthenticationViewModelBuilder {
    func with(email: String) -> Self {
        self.email = email
        
        return self
    }
    
    func with(password: String) -> Self {
        self.password = password
        
        return self
    }
    
    func with(userService: UserService) -> Self {
        self.userService = userService
        
        return self
    }
    
    func with(authService: AuthService) -> Self {
        self.authService = authService
        
        return self
    }
    
    func with(validator: Validator) -> Self {
        self.validator = validator
        
        return self
    }
    
    func makeEmailValid() -> Self {
        self.email = "test@test.com"
        
        return self
    }
    
    func makePasswordValid() -> Self {
        self.password = "12345aA!"
        
        return self
    }
    
    func makeEmailNotValid() -> Self {
        self.email = "Not valid email"
        
        return self
    }
    
    func makePasswordNotValid() -> Self {
        self.password = "Not valid password"
        
        return self
    }
    
    func makeAuthServiceOutputFailure() -> Self {
        authService = TestDoublesFactory.getAuthServiceStub(result: .failure)
        
        return self
    }
}
