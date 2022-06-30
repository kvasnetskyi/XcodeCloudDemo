//
//  AuthSelectView.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import UIKit
import Combine

enum AuthSelectViewAction {
    case signIn
    case signUp
}

final class AuthSelectView: BaseView {
    // MARK: - Subviews
    private let buttonsStack = UIStackView()
    private let signInButton = UIButton()
    private let signUpButton = UIButton()
    
    // MARK: - Internal Properties
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    
    // MARK: - Private Properties
    private let actionSubject = PassthroughSubject<AuthSelectViewAction, Never>()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
extension AuthSelectView {
    func commonInit() {
        setupLayout()
        setupUI()
        setupBinding()
    }
    
    func setupLayout() {
        buttonsStack.setup(
            axis: .vertical,
            alignment: .fill,
            distribution: .fillEqually,
            spacing: Constant.buttonSpacing
        )
        
        buttonsStack.addArranged(signInButton, size: Constant.buttonHeight)
        buttonsStack.addArranged(signUpButton)
        
        let leading = buttonsStack
            .leadingAnchor
            .constraint(
                equalTo: leadingAnchor,
                constant: Constant.buttonOffset
            )
        
        let trailing = buttonsStack
            .trailingAnchor
            .constraint(
                equalTo: trailingAnchor,
                constant: -Constant.buttonOffset
            )
        
        let bottom = buttonsStack
            .bottomAnchor
            .constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -Constant.buttonOffset
            )
        
        addSubview(buttonsStack, constraints: [leading, trailing, bottom])
    }

    func setupUI() {
        backgroundColor = .white
        signInButton.setTitle(Localization.signIn, for: .normal)
        signUpButton.setTitle(Localization.signUp, for: .normal)

        [signInButton, signUpButton].forEach {
            $0.titleLabel?.font = FontFamily.Montserrat.semiBold.font(size: 15)
            $0.backgroundColor = .systemBlue
            $0.rounded(12)
        }
    }
    
    func setupBinding() {
        signInButton.tapPublisher
            .sink { [unowned self] in actionSubject.send(.signIn) }
            .store(in: &subscriptions)

        signUpButton.tapPublisher
            .sink { [unowned self] in actionSubject.send(.signUp) }
            .store(in: &subscriptions)
    }
}

// MARK: - Static Properties
private enum Constant {
    static let buttonOffset: CGFloat = 20
    static let buttonSpacing: CGFloat = 16
    static let buttonHeight: CGFloat = 50
}

// MARK: - PreviewProvider
import SwiftUI
struct AuthSelectViewPreview: PreviewProvider {
    static var previews: some View {
        ViewRepresentable(AuthSelectView())
    }
}
