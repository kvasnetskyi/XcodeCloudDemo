//
//  SignInView.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import UIKit
import Combine

enum SignInViewAction {
    case emailChanged(String)
    case passwordChanged(String)
    case doneTapped
}

final class SignInView: BaseView {
    // MARK: - Subviews
    private let scrollView = AxisScrollView()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let doneButton = UIButton()
    
    // MARK: - Internal Properties
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    
    // MARK: - Private Properties
    private let actionSubject = PassthroughSubject<SignInViewAction, Never>()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal Methods
extension SignInView {
    func setDoneButton(enabled: Bool) {
        doneButton.isEnabled = enabled
        doneButton.alpha = enabled ? 1 : 0.5
    }
}

// MARK: - Private Methods
private extension SignInView {
    func commonInit() {
        setupLayout()
        setupUI()
        setupBinding()
    }
    
    func setupLayout() {
        let stack = UIStackView()
        stack.setup(
            axis: .vertical,
            alignment: .fill,
            distribution: .fill,
            spacing: Constant.textFieldSpacing
        )
        
        stack.addArranged(emailTextField, size: Constant.textFieldHeight)
        stack.addArranged(passwordTextField, size: Constant.textFieldHeight)
        stack.addSpacer(Constant.textFieldSpacing)
        stack.addArranged(doneButton, size: Constant.doneButtonHeight)
        
        addSubview(
            scrollView,
            withEdgeInsets: .zero,
            safeArea: true,
            bottomToKeyboard: true
        )
        
        scrollView.contentView.addSubview(
            stack, withEdgeInsets: .all(Constant.containerSpacing)
        )
    }
    
    func setupUI() {
        backgroundColor = .white
        emailTextField.placeholder = Localization.email
        passwordTextField.placeholder = Localization.password

        [emailTextField, passwordTextField].forEach {
            $0.borderStyle = .roundedRect
        }

        doneButton.setTitle(Localization.signUp, for: .normal)
        doneButton.backgroundColor = .systemBlue
        doneButton.rounded(12)
    }
    
    func setupBinding() {
        emailTextField.textPublisher
            .replaceNil(with: String.empty)
            .sink { [unowned self] in actionSubject.send(.emailChanged($0)) }
            .store(in: &subscriptions)

        passwordTextField.textPublisher
            .replaceNil(with: String.empty)
            .sink { [unowned self] in actionSubject.send(.passwordChanged($0)) }
            .store(in: &subscriptions)

        doneButton.tapPublisher
            .sink { [unowned self] in actionSubject.send(.doneTapped) }
            .store(in: &subscriptions)
    }
}

// MARK: - Static Properties
private enum Constant {
    static let textFieldHeight: CGFloat = 50
    static let doneButtonHeight: CGFloat = 50
    static let textFieldSpacing: CGFloat = 16
    static let containerSpacing: CGFloat = 16
}

// MARK: - PreviewProvider
#if DEBUG
import SwiftUI
struct SignInPreview: PreviewProvider {
    static var previews: some View {
        ViewRepresentable(SignInView())
    }
}
#endif
