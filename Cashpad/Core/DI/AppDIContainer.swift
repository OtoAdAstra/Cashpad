//
//  AppDIContainer.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 12.01.26.
//


import CoreData

final class AppDIContainer {

    static let shared = AppDIContainer()

    private let persistenceController: PersistenceController
    private let exchangeService: ExchangeServiceProtocol
    private let exchangeCache: ExchangeRateCacheProtocol
    private let themeManager: ThemeManagerProtocol
    private let securityService: SecurityServiceProtocol

    private init() {
        self.persistenceController = PersistenceController.shared
        self.exchangeService = ExchangeService(
            apiKey: AppSecrets.exchangeApiKey
        )
        self.exchangeCache = ExchangeRateCache()
        self.themeManager = ThemeManager()
        self.securityService = SecurityService()
    }

    // MARK: - Repositories

    func makeAccountRepository() -> AccountRepositoryProtocol {
        AccountRepository(
            context: persistenceController.container.viewContext
        )
    }
    
    func makeTransactionRepository() -> TransactionRepositoryProtocol {
        TransactionRepository(
            context: persistenceController.container.viewContext
        )
    }
    
    func makeExchangeRepository() -> ExchangeRepositoryProtocol {
        ExchangeRepository(service: exchangeService, cache: exchangeCache)
    }
    
    // MARK: - Services
    
    func makeThemeManager() -> ThemeManagerProtocol {
        themeManager
    }
    
    func makeSecurityService() -> SecurityServiceProtocol {
        securityService
    }

    // MARK: - ViewModels

    func makeAccountsViewModel() -> AccountsViewModel {
        AccountsViewModel(
            repository: makeAccountRepository(),
            themeManager: makeThemeManager(),
            securityService: makeSecurityService(),
            exchangeRepository: makeExchangeRepository()
        )
    }
    
    func makeBalanceViewModel(accountId: UUID) -> BalanceViewModel {
        BalanceViewModel(
            accountId: accountId,
            transactionRepository: makeTransactionRepository(),
            accountRepository: makeAccountRepository()
        )
    }
    
    func makeChartViewModel(accountId: UUID) -> ChartViewModel {
        ChartViewModel(
            accountId: accountId,
            transactionRepository: makeTransactionRepository(),
            accountRepository: makeAccountRepository()
        )
    }
    
    func makeExchangeViewModel() -> ExchangeViewModel {
        ExchangeViewModel(
            repository: makeExchangeRepository()
        )
    }
    
}
