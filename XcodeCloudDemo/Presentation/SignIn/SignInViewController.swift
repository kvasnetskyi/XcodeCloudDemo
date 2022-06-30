//
//  SignInViewController.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import UIKit

final class SignInViewController: BaseViewController<SignInViewModel> {
    // MARK: - Views
    private let contentView = SignInView()
    
    // MARK: - Life Cycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        
        title = Localization.signIn.uppercased()
    }
}

// MARK: - Private Methods
private extension SignInViewController {
    func setupBinding() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .emailChanged(let text):
                    viewModel.email = text

                case .passwordChanged(let text):
                    viewModel.password = text

                case .doneTapped:
                    viewModel.signInUser()
                }
            }
            .store(in: &subscriptions)

        viewModel.$isInputValid
            .sink { [unowned self] in contentView.setDoneButton(enabled: $0) }
            .store(in: &subscriptions)
    }
}
