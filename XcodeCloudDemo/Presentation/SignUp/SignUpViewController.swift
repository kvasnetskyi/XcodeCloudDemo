//
//  SignUpViewController.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import UIKit

final class SignUpViewController: BaseViewController<SignUpViewModel> {
    // MARK: - Views
    private let contentView = SignUpView()
    
    // MARK: - Life Cycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        setupBinding()
        
        super.viewDidLoad()
        
        title = Localization.signUp.uppercased()
    }
}

// MARK: - Private Methods
private extension SignUpViewController {
    func setupBinding() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .emailChanged(let text):
                    viewModel.email = text

                case .passwordChanged(let text):
                    viewModel.password = text

                case .confirmPasswordChanged(let text):
                    viewModel.confirmPassword = text

                case .doneTapped:
                    viewModel.signUpUser()
                }
            }
            .store(in: &subscriptions)

        viewModel.$isInputValid
            .sink { [unowned self] isValid in
                contentView.setDoneButton(enabled: isValid)
            }
            .store(in: &subscriptions)
    }
}
