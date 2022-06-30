//
//  HomeCoordinator.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import UIKit
import Combine

final class HomeCoordinator: Coordinator {
    // MARK: - Internal Properties
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    
    // MARK: - Private Properties
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private let container: AppContainer
    
    // MARK: - Init
    init(navigationController: UINavigationController, container: AppContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let viewController = HomeModuleBuilder.build(container: container)
        setRoot(viewController)
    }
}
