//
//  AuthSelectModuleBuilder.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import UIKit
import Combine

enum AuthSelectTransition: Transition {
    case signIn, signUp
}

final class AuthSelectModuleBuilder {
    class func build() -> Module<AuthSelectTransition, UIViewController> {
        let viewModel = AuthSelectViewModel()
        let viewController = AuthSelectViewController(viewModel: viewModel)
        
        return Module(
            viewController: viewController,
            transitionPublisher: viewModel.transitionPublisher
        )
    }
}
