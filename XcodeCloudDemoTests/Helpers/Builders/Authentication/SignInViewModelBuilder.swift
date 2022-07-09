//
//  SignInViewModelBuilder.swift
//  XcodeCloudDemoTests
//
//  Created by Artem Kvasnetskyi on 09.07.2022.
//

import Foundation

@testable import XcodeCloudDemo

final class SignInViewModelBuilder: BaseAuthenticationViewModelBuilder {
    func build() -> SignInViewModel {
        let viewModel = SignInViewModel(
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
        
        viewState.setViewState(viewModel)
        
        return viewModel
    }
}
