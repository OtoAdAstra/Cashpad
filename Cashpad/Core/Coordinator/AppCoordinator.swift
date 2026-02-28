//
//  AppCoordinator.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 06.01.26.
//

import UIKit

final class AppCoordinator: Coordinator {

    var navigationController: UINavigationController
    private let diContainer: AppDIContainer

    private var accountsCoordinator: AccountsCoordinator?

    init(navigationController: UINavigationController, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }

    func start() {
        let coordinator = AccountsCoordinator(
            navigationController: navigationController,
            diContainer: diContainer
        )
        self.accountsCoordinator = coordinator
        coordinator.start()
    }
}
