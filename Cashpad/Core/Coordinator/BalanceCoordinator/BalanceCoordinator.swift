//
//  BalanceCoordinator.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 06.01.26.
//

import UIKit
import SwiftUI

final class BalanceCoordinator: Coordinator {
    
    private let diContainer: AppDIContainer
    
    var navigationController: UINavigationController
    let account: AccountModel
    
    var onFinish: (() -> Void)?
    
    init(
        navigationController: UINavigationController,
        account: AccountModel,
        diContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.account = account
        self.diContainer = diContainer
    }
    
    func start() {
        let balanceViewModel = diContainer.makeBalanceViewModel(
            accountId: account.id
        )
        let chartViewModel = diContainer.makeChartViewModel(
            accountId: account.id
        )
                        
        let vc = BalanceViewController(
            account: account,
            viewModel: balanceViewModel,
            chartViewModel: chartViewModel,
            onBack: { [weak self] in
                self?.navigationController.popViewController(animated: true)
                self?.onFinish?()
            },
            onExchange: { [weak self] in
                guard let self = self else { return }
                
                let exchangeViewModel = diContainer.makeExchangeViewModel()
                let exchangeVC = ExchangeViewController(viewModel: exchangeViewModel)
                self.navigationController.pushViewController(exchangeVC, animated: true)
            }
        )
        
        navigationController.pushViewController(vc, animated: true)
    }
}

