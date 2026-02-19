//
//  AppCoordinator.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 06.01.26.
//

import UIKit

final class AppCoordinator: Coordinator {

    var navigationController: UINavigationController

    private var accountsCoordinator: AccountsCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let coordinator = AccountsCoordinator(
            navigationController: navigationController
        )
        self.accountsCoordinator = coordinator
        coordinator.start()
    }
}
