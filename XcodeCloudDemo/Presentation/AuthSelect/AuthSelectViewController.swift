//
//  AuthSelectViewController.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import UIKit

final class AuthSelectViewController: BaseViewController<AuthSelectViewModel> {
    // MARK: - Views
    private let contentView = AuthSelectView()
    
    // MARK: - Life Cycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBinding()
    }
}

// MARK: - Private Methods
private extension AuthSelectViewController {
    func setupBinding() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .signIn: viewModel.showSignIn()
                case .signUp: viewModel.showSignUp()
                }
            }
            .store(in: &subscriptions)
    }
}
