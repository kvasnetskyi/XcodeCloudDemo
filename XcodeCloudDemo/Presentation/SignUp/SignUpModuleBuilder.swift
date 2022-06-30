//
//  SignUpModuleBuilder.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import UIKit
import Combine

enum SignUpTransition: Transition {
    case success
}

final class SignUpModuleBuilder {
    class func build(container: AppContainer) -> Module<SignUpTransition, UIViewController> {
        let viewModel = SignUpViewModel(
            authService: container.authService,
            userService: container.userService,
            validator: container.validator
        )
        
        let viewController = SignUpViewController(viewModel: viewModel)
        
        return Module(
            viewController: viewController,
            transitionPublisher: viewModel.transitionPublisher
        )
    }
}
