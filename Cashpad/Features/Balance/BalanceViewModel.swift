//
//  BalanceViewModel.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 14.01.26.
//

import Foundation
import Combine

@MainActor
final class BalanceViewModel: ObservableObject {
    
    // MARK: - Dependencies
    private let accountId: UUID
    private let transactionRepository: TransactionRepositoryProtocol
    private let accountRepository: AccountRepositoryProtocol
    
    // MARK: - Published State
    @Published private(set) var transactions: [Transaction] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var balance: Double = 0
    @Published private(set) var currencySymbol: String = ""
    @Published var error: Error?
    @Published private(set) var currentFilter: TransactionFilter = .empty
    @Published private(set) var isFilterApplied: Bool = false
    @Published var searchText: String = ""
    
    // MARK: - Stored original transactions for filtering
    private var originalTransactions: [Transaction] = []
    
    // MARK: - Derived Collections
    var filteredTransactions: [Transaction] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let allTransactions = transactions
        let matchingTransactions: [Transaction]
        if query.isEmpty {
            matchingTransactions = allTransactions
        } else {
            matchingTransactions = allTransactions.filter { transaction in
                let searchTarget: String
                if let note = transaction.note, !note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    searchTarget = note.lowercased()
                } else {

                    let typeString: String
                    switch Int(transaction.type) {
                    case 0:
                        typeString = TransactionType.income.rawValue
                    case 1:
                        typeString = TransactionType.expense.rawValue
                    default:
                        typeString = String(describing: transaction.type)
                    }
                    searchTarget = typeString.lowercased()
                }
                return searchTarget.contains(query)
            }
        }
        
        return matchingTransactions.sorted { (lhs, rhs) in
            let lhsDate = lhs.date ?? .distantPast
            let rhsDate = rhs.date ?? .distantPast
            return lhsDate > rhsDate
        }
    }
    
    var groupedTransactions: [Date: [Transaction]] {
        let calendar = Calendar.current
        let groups = Dictionary(grouping: filteredTransactions) { (transaction: Transaction) -> Date in
            let date = transaction.date ?? .distantPast
            return calendar.startOfDay(for: date)
        }
        return groups.mapValues { list in
            list.sorted { (lhs, rhs) in
                let lhsDate = lhs.date ?? .distantPast
                let rhsDate = rhs.date ?? .distantPast
                return lhsDate > rhsDate
            }
        }
    }
    
    // MARK: - Formatting
    private lazy var dateHeaderFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df
    }()
    
    func headerString(for day: Date) -> String {
        dateHeaderFormatter.string(from: day)
    }
    
    // MARK: - Init
    init(
        accountId: UUID,
        transactionRepository: TransactionRepositoryProtocol,
        accountRepository: AccountRepositoryProtocol
    ) {
        self.accountId = accountId
        self.transactionRepository = transactionRepository
        self.accountRepository = accountRepository
    }
    
    // MARK: - Load
    func loadTransactions() {
        isLoading = true
        error = nil
        do {
            let fetched = try transactionRepository.fetchTransactions(
                accountId: accountId
            )
            originalTransactions = fetched
            transactions = fetched
            
            recomputeBalance()
            
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    private func recomputeBalance() {
        let newBalance = transactions.reduce(0.0) { result, transaction in
            result + transaction.amount
        }
        balance = newBalance
        
        do {
            let account = try accountRepository.fetchAccount(by: accountId)
            let currency = Currency(rawValue: account.currency ?? "") ?? .usd
            currencySymbol = currency.symbol
        } catch {
            currencySymbol = Currency.usd.symbol
        }
    }
    
    // MARK: - Add
    func addTransaction(
        amount: Double,
        date: Date,
        note: String?,
        type: TransactionType
    ) {
        do {
            let account = try accountRepository.fetchAccount(by: accountId)
            
            _ = try transactionRepository.createTransaction(
                account: account,
                amount: amount,
                date: date,
                note: note,
                type: type
            )
            
            loadTransactions()
        } catch {
            self.error = error
        }
    }
    
    // MARK: - Delete
    func deleteTransaction(_ transaction: Transaction) {
        do {
            try transactionRepository.deleteTransaction(transaction)
            transactions.removeAll { $0.id == transaction.id }
            originalTransactions.removeAll { $0.id == transaction.id }
            recomputeBalance()
        } catch {
            self.error = error
        }
    }
    
    func apply(filter: TransactionFilter) {
        currentFilter = filter
        isFilterApplied = !filter.isEmpty
        
        let calendar = Calendar.current
        
        transactions = originalTransactions.filter { transaction in
            guard let transactionDate = transaction.date else { return false }
            
            if let start = filter.startDate {
                let startDay = calendar.startOfDay(for: start)
                if transactionDate < startDay { return false }
            }
            
            if let end = filter.endDate {
                let endDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: end) ?? end
                if transactionDate > endDay { return false }
            }
            
            if let min = filter.minAmount, transaction.amount < min { return false }
            
            if let max = filter.maxAmount, transaction.amount > max { return false }
            
            return true
        }
    }
    
    func resetFilters() {
        currentFilter = .empty
        isFilterApplied = false
        transactions = originalTransactions
    }
}

