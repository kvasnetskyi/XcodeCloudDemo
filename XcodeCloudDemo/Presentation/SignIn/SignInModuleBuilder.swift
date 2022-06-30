//
//  SignInModuleBuilder.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import UIKit
import Combine

enum SignInTransition: Transition {
    case success
}

final class SignInModuleBuilder {
    class func build(container: AppContainer) -> Module<SignInTransition, UIViewController> {
        let viewModel = SignInViewModel(
            authService: container.authService,
            userService: container.userService,
            validator: container.validator
        )
        
        let viewController = SignInViewController(viewModel: viewModel)
        
        return Module(
            viewController: viewController,
            transitionPublisher: viewModel.transitionPublisher
        )
    }
}
