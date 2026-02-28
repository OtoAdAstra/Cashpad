//
//  AccuntsViewModel.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 12.01.26.
//

import Combine
import Foundation

@MainActor
final class AccountsViewModel: ObservableObject {

    // MARK: - Published State
    @Published private(set) var accounts: [AccountModel] = []
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var requireFaceID: Bool
    @Published var selectedCurrency: String {
        didSet {
            updateTotalConvertedBalance()
        }
    }
    @Published var selectedTheme: AppTheme
    @Published private(set) var totalConvertedBalance: Double = 0

    // MARK: - Dependencies
    private let repository: AccountRepositoryProtocol
    private let themeManager: ThemeManagerProtocol
    private let securityService: SecurityServiceProtocol
    private let exchangeRepository: ExchangeRepositoryProtocol

    // MARK: - Initialization
    init(
        repository: AccountRepositoryProtocol,
        themeManager: ThemeManagerProtocol,
        securityService: SecurityServiceProtocol,
        exchangeRepository: ExchangeRepositoryProtocol
    ) {
        self.repository = repository
        self.themeManager = themeManager
        self.selectedTheme = themeManager.theme
        self.securityService = securityService
        self.requireFaceID = securityService.isFaceIDEnabled
        let storedCurrency = UserDefaults.standard.string(forKey: "SelectedCurrency") ?? "USD"
        self.selectedCurrency = storedCurrency
        self.exchangeRepository = exchangeRepository
    }

    // MARK: - Loading & Mutations
    func loadAccounts() {
        isLoading = true
        errorMessage = nil

        do {
            let cdAccounts = try repository.fetchAccounts()
            accounts = cdAccounts.map { Self.mapToModel($0) }
            updateTotalConvertedBalance()
        } catch {
            errorMessage = "Failed to load accounts"
        }

        isLoading = false
    }

    func addAccount(
        name: String,
        currency: String,
        emoji: String?,
        color: String?,
        initialBalance: Double
    ) {
        do {
            let account = try repository.createAccount(
                name: name,
                currency: currency,
                emoji: emoji,
                color: color
            )

            if initialBalance > 0 {
                try repository.addInitialTransaction(
                    to: account,
                    amount: initialBalance
                )
            }

            loadAccounts()
        } catch {
            errorMessage = "Failed to create account"
        }
    }

    func deleteAccount(at index: Int) {
        guard accounts.indices.contains(index) else { return }

        do {
            let cdAccounts = try repository.fetchAccounts()
            let accountToDelete = cdAccounts[index]
            try repository.deleteAccount(accountToDelete)
            loadAccounts()
        } catch {
            errorMessage = "Failed to delete account"
        }
    }
    
    func clearAccounts() {
        do {
            try repository.deleteAllAccounts()
            loadAccounts()
        } catch {
            errorMessage = "Failed to clear accounts"
        }
    }

    // MARK: - Formatting
    var totalBalanceString: String {
        String(format: "%.2f", totalConvertedBalance)
    }

    func formattedBalance(for account: AccountModel) -> String {
        String(format: "%.2f", account.balance)
    }

    // MARK: - Settings
    func updateTheme(_ theme: AppTheme) {
        themeManager.theme = theme
    }

    func updateFaceID(_ enabled: Bool) {
        securityService.setFaceID(enabled)
        requireFaceID = enabled
    }

    // MARK: - Currency
    func updateCurrency(_ currency: String) {
        selectedCurrency = currency
        UserDefaults.standard.set(currency, forKey: "SelectedCurrency")
    }

    // MARK: - Spending Trend
    func totalSpendingTrend() -> SpendingTrend {
        guard let cdAccounts = try? repository.fetchAccounts() else { return .same }
        return SpendingTrendCalculator.totalTrend(for: cdAccounts)
    }

    func spendingTrendsByAccount() -> [UUID: SpendingTrend] {
        guard let cdAccounts = try? repository.fetchAccounts() else { return [:] }
        return SpendingTrendCalculator.trendsByAccount(for: cdAccounts)
    }

    func spendingTrend(for account: AccountModel) -> SpendingTrend {
        let trends = spendingTrendsByAccount()
        return trends[account.id] ?? .same
    }

    // MARK: - Private Helpers
    private func updateTotalConvertedBalance() {
        guard !accounts.isEmpty else {
            totalConvertedBalance = 0
            return
        }

        Task { [accounts, selectedCurrency] in
            do {
                let rates = try await exchangeRepository.getLatestRates(base: "USD")

                let total = accounts.reduce(0.0) { sum, account in
                    sum + rates.convert(
                        amount: account.balance,
                        from: account.currency,
                        to: selectedCurrency
                    )
                }

                await MainActor.run {
                    self.totalConvertedBalance = total
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to fetch exchange rates"
                    self.totalConvertedBalance = 0
                }
            }
        }
    }

    private static func mapToModel(_ account: Account) -> AccountModel {
        let transactions = account.transactions as? Set<Transaction> ?? []

        let balance = transactions.reduce(0.0) { result, transaction in
            result + transaction.amount
        }

        return AccountModel(
            id: account.id ?? UUID(),
            name: account.name ?? "",
            currency: account.currency ?? "",
            emoji: account.emoji,
            color: account.color,
            createdAt: account.createdAt ?? Date(),
            balance: balance
        )
    }
}

