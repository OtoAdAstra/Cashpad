//
//  ChartViewModel.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 15.01.26.
//

import Combine
import SwiftUI

@MainActor
final class ChartViewModel: ObservableObject {
    // MARK: - Dependencies
    private let accountId: UUID
    private let transactionRepository: TransactionRepositoryProtocol
    private let accountRepository: AccountRepositoryProtocol

    // MARK: - Published State
    @Published var selectedFlow: Flow = .expense { didSet { cachedAggregated.removeAll() } }
    @Published var selectedGranularity: Granularity = .week { didSet { cachedAggregated.removeAll() } }
    @Published var currentAnchorDate: Date = Date() { didSet { cachedAggregated.removeAll() } }
    @Published var selectedTX: Transaction?
    @Published private(set) var transactions: [Transaction] = []
    @Published private(set) var currency: Currency = .usd

    // MARK: - Init
    init(accountId: UUID, transactionRepository: TransactionRepositoryProtocol, accountRepository: AccountRepositoryProtocol) {
        self.accountId = accountId
        self.transactionRepository = transactionRepository
        self.accountRepository = accountRepository
        self.transactions = []
        loadTransactions()
        loadCurrency()
    }

    func loadTransactions() {
        do {
            let coreDataTransactions = try transactionRepository.fetchTransactions(accountId: accountId)
            self.transactions = coreDataTransactions
            cachedAggregated.removeAll()
        } catch {
            self.transactions = []
            cachedAggregated.removeAll()
        }
    }

    private func loadCurrency() {
        do {
            let account = try accountRepository.fetchAccount(by: accountId)
            let code = account.currency ?? "USD"
            self.currency = Currency(rawValue: code) ?? .usd
        } catch {
            self.currency = .usd
        }
    }

    func reload(with transactions: [Transaction]) {
        self.transactions = transactions
        cachedAggregated.removeAll()
    }

    // MARK: - Calendar & Cache
    private let calendar = Calendar.current

    private struct PeriodKey: Hashable {
        let flow: Flow
        let granularity: Granularity
        let anchorDay: Date
    }

    private var cachedAggregated: [PeriodKey: [(date: Date, total: Double)]] = [:]

    // MARK: - Derived Data
    var filtered: [Transaction] {
        let type = (selectedFlow == .income) ? 0 : 1
        return transactions
            .lazy
            .filter { Int($0.type) == type }
            .sorted { ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast) }
    }

    var periodRange: Range<Date> {
        let lower = normalizedAnchorStart()
        let upper: Date
        switch selectedGranularity {
        case .day:
            upper = calendar.date(byAdding: .day, value: 1, to: lower) ?? lower
        case .week:
            upper = calendar.date(byAdding: .weekOfYear, value: 1, to: lower) ?? lower
        case .year:
            upper = calendar.date(byAdding: .year, value: 1, to: lower) ?? lower
        }
        return lower..<upper
    }

    private func normalizedAnchorStart() -> Date {
        switch selectedGranularity {
        case .day:
            return calendar.startOfDay(for: currentAnchorDate)
        case .week:
            let comps = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentAnchorDate)
            return calendar.date(from: comps) ?? calendar.startOfDay(for: currentAnchorDate)
        case .year:
            let comps = calendar.dateComponents([.year], from: currentAnchorDate)
            return calendar.date(from: comps) ?? calendar.startOfDay(for: currentAnchorDate)
        }
    }

    var periodFiltered: [Transaction] {
        let r = periodRange
        return filtered.filter { r.contains($0.date ?? Date.distantPast) }
    }
    
    var periodIncomeTotal: Double {
        transactions
            .filter { Int($0.type) == 0 }
            .filter { periodRange.contains($0.date ?? Date()) }
            .reduce(0) { $0 + $1.amount }
    }
    
    var periodExpenseTotal: Double {
        transactions
            .filter { Int($0.type) == 1 }
            .filter { periodRange.contains($0.date ?? Date()) }
            .reduce(0) { $0 + abs($1.amount) }
    }

    var periodNetTotal: Double {
        periodIncomeTotal - periodExpenseTotal
    }

    var periodSelectedFlowTotal: Double {
        switch selectedFlow {
        case .income: return periodIncomeTotal
        case .expense: return periodExpenseTotal
        }
    }

    var aggregated: [(date: Date, total: Double)] {
        let key = PeriodKey(flow: selectedFlow, granularity: selectedGranularity, anchorDay: normalizedAnchorStart())
        if let cached = cachedAggregated[key] {
            return cached
        }

        let buckets = Dictionary(grouping: periodFiltered) { tx -> Date in
            let date = tx.date ?? Date()
            switch selectedGranularity {
            case .day:
                let comps = calendar.dateComponents([.year, .month, .day, .hour], from: date)
                return calendar.date(from: comps) ?? calendar.startOfDay(for: date)
            case .week:
                return calendar.startOfDay(for: date)
            case .year:
                let comps = calendar.dateComponents([.year, .month], from: date)
                return calendar.date(from: comps) ?? calendar.startOfDay(for: date)
            }
        }

        let pairs = buckets.map { (key, values) in
            let total: Double
            if selectedFlow == .expense {
                total = values.reduce(0) { $0 + abs($1.amount) }
            } else {
                total = values.reduce(0) { $0 + $1.amount }
            }
            return (date: key, total: total)
        }.sorted { $0.date < $1.date }

        cachedAggregated[key] = pairs
        return pairs
    }

    // MARK: - Intent
    func shiftPeriod(_ delta: Int) {
        let cal = Calendar.current
        cachedAggregated.removeAll()
        switch selectedGranularity {
        case .day:
            currentAnchorDate =
                cal.date(byAdding: .day, value: delta, to: currentAnchorDate)
                ?? currentAnchorDate
        case .week:
            currentAnchorDate =
                cal.date(
                    byAdding: .weekOfYear,
                    value: delta,
                    to: currentAnchorDate
                ) ?? currentAnchorDate
        case .year:
            currentAnchorDate =
                cal.date(byAdding: .year, value: delta, to: currentAnchorDate)
                ?? currentAnchorDate
        }
    }

    var periodTitle: String {
        let formatter = DateFormatter()
        switch selectedGranularity {
        case .day:
            formatter.setLocalizedDateFormatFromTemplate("MMM d")
            return formatter.string(from: periodRange.lowerBound)
        case .week:
            let dif = DateIntervalFormatter()
            dif.dateStyle = .medium
            dif.timeStyle = .none
            let lower = periodRange.lowerBound
            let upper = periodRange.upperBound.addingTimeInterval(-1)
            return dif.string(from: lower, to: upper)
        case .year:
            formatter.dateFormat = "yyyy"
            return formatter.string(from: periodRange.lowerBound)
        }
    }

    // MARK: - UI Helpers
    var selectedFlowColor: Color {
        switch selectedFlow {
        case .income: return Color.green
        case .expense: return Color.red
        }
    }

    static func color(for flow: Flow) -> Color {
        switch flow {
        case .income: return Color.green
        case .expense: return Color.red
        }
    }
}

