//
//  AuthCoordinator.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import UIKit
import Combine

final class AuthCoordinator: Coordinator {
    // MARK: - Internal Properties
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    
    // MARK: - Private Properties
    private let container: AppContainer
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(navigationController: UINavigationController, container: AppContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let module = AuthSelectModuleBuilder.build()
        
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .signIn: signIn()
                case .signUp: signUp()
                }
            }
            .store(in: &cancellables)
        
        push(module.viewController)
    }
}

// MARK: - Private Methods
private extension AuthCoordinator {
    func signIn() {
        let module = SignInModuleBuilder.build(container: container)
        
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .success: didFinishSubject.send()
                }
            }
            .store(in: &cancellables)
        
        push(module.viewController)
    }
    
    func signUp() {
        let module = SignUpModuleBuilder.build(container: container)
        
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .success: didFinishSubject.send()
                }
            }
            .store(in: &cancellables)
        
        push(module.viewController)
    }
}
