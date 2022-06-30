//
//  AppCoordinator.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import UIKit
import Combine

final class AppCoordinator: Coordinator {
    // MARK: - Internal Properties
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    
    // MARK: - Private Properties
    private var window: UIWindow
    private let container: AppContainer
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
        window: UIWindow,
        container: AppContainer,
        navigationController: UINavigationController = .init()
    ) {
        self.window = window
        self.container = container
        self.navigationController = navigationController
    }
    
    func start() {
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
        
        container.userService.isAuthorized ? mainFlow() : authFlow()
    }
}

// MARK: - Private Methods
private extension AppCoordinator {
    func authFlow() {
        let authCoordinator = AuthCoordinator(
            navigationController: navigationController,
            container: container
        )
        
        childCoordinators.append(authCoordinator)
        
        authCoordinator.didFinishPublisher
            .sink { [unowned self] in
                mainFlow()
                removeChild(coordinator: authCoordinator)
            }
            .store(in: &cancellables)
        
        authCoordinator.start()
    }

    func mainFlow() {
        let homeCoordinator = HomeCoordinator(
            navigationController: navigationController,
            container: container
        )
        
        childCoordinators.append(homeCoordinator)
        
        homeCoordinator.didFinishPublisher
            .sink { [unowned self] in
                authFlow()
                removeChild(coordinator: homeCoordinator)
            }
            .store(in: &cancellables)
        
        homeCoordinator.start()
    }
}
