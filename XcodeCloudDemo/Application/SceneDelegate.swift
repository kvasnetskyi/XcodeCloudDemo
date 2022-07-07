//
//  SceneDelegate.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import UIKit
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Internal Properties
    var window: UIWindow?
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private var appCoordinator: AppCoordinator!
    private var appContainer: AppContainer!
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        print("Debug: Test")
        
        self.window = UIWindow(windowScene: windowScene)
        self.appContainer = AppContainerImpl()
        self.appCoordinator = AppCoordinator(
            window: window!,
            container: appContainer
        )
        
        self.appCoordinator?.start()
    }
}

