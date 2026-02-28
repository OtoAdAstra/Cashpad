//
//  AccountsCoordinator.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 06.01.26.
//

import CoreData
import SwiftUI
import UIKit

final class AccountsCoordinator: Coordinator {

    var navigationController: UINavigationController
    private let diContainer: AppDIContainer
    
    private var balanceCoordinator: BalanceCoordinator?

    init(
        navigationController: UINavigationController,
        diContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }

    func start() {

        let viewModel = diContainer.makeAccountsViewModel()

        let accountsView = AccountsView(
            viewModel: viewModel,
            onAccountSelected: { [weak self] account in
                self?.showBalance(for: account)
            }
        )

        let hostingVC = UIHostingController(rootView: accountsView)
        navigationController.setViewControllers([hostingVC], animated: false)
    }

    private func showBalance(for account: AccountModel) {
        let coordinator = BalanceCoordinator(
            navigationController: navigationController,
            account: account,
            diContainer: diContainer
        )
        
        coordinator.onFinish = { [weak self] in
            self?.balanceCoordinator = nil
        }

        self.balanceCoordinator = coordinator
        coordinator.start()
    }}
