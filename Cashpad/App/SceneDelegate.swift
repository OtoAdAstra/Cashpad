//
//  SceneDelegate.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 06.01.26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    private let di = AppDIContainer.shared
    
    private lazy var authHelper = AppAuthenticationHelper(
        securityService: di.makeSecurityService()
    )

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        
        let themeManager = di.makeThemeManager()
        
        themeManager.theme.apply(to: window)

        themeManager.onThemeChange = { [weak window] theme in
            guard let window else { return }
            theme.apply(to: window)
        }
        
        let navigationController = UINavigationController()
        let coordinator = AppCoordinator(navigationController: navigationController, diContainer: di)
        
        coordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        self.window = window
        self.appCoordinator = coordinator
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        guard let window = window else { return }
        authHelper.authenticateIfNeeded(window: window)
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        authHelper.resetSession()
    }
}

