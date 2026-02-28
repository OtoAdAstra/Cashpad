//
//  SpendingTrendCalculator.swift
//  Cashpad
//

import Foundation


enum SpendingTrendCalculator {

    static func trend(for transactions: Set<Transaction>) -> SpendingTrend {
        let calendar = Calendar.current
        let now = Date()
        let currentMonthInterval = calendar.dateInterval(of: .month, for: now)

        var monthlySpend: [DateComponents: Double] = [:]

        for transaction in transactions {
            let amount = transaction.amount
            guard amount < 0 else { continue }

            let transactionDate = transaction.date ?? now
            let components = calendar.dateComponents([.year, .month], from: transactionDate)
            monthlySpend[components, default: 0] += -amount
        }

        var thisMonthSpend: Double = 0
        if let interval = currentMonthInterval {
            for transaction in transactions {
                let amount = transaction.amount
                guard amount < 0 else { continue }
                if let transactionDate = transaction.date, interval.contains(transactionDate) {
                    thisMonthSpend += -amount
                }
            }
        }

        let averageMonthly = historicalAverage(
            monthlySpend: monthlySpend,
            calendar: calendar,
            now: now
        )

        return compareTrend(thisMonth: thisMonthSpend, average: averageMonthly)
    }

    static func totalTrend(for accounts: [Account]) -> SpendingTrend {
        let allTransactions: Set<Transaction> = accounts.reduce(into: []) { result, account in
            let transactions = (account.transactions as? Set<Transaction>) ?? []
            result.formUnion(transactions)
        }
        return trend(for: allTransactions)
    }

    static func trendsByAccount(for accounts: [Account]) -> [UUID: SpendingTrend] {
        var result: [UUID: SpendingTrend] = [:]
        for account in accounts {
            let accountId = account.id ?? UUID()
            let transactions = (account.transactions as? Set<Transaction>) ?? []
            result[accountId] = trend(for: transactions)
        }
        return result
    }

    // MARK: - Private Helpers

    private static func historicalAverage(
        monthlySpend: [DateComponents: Double],
        calendar: Calendar,
        now: Date
    ) -> Double {
        let historicalMonths = monthlySpend.filter { components, _ in
            if let year = components.year, let month = components.month,
               let currentYear = calendar.dateComponents([.year], from: now).year,
               let currentMonth = calendar.dateComponents([.month], from: now).month {
                return !(year == currentYear && month == currentMonth)
            }
            return true
        }

        let spends = Array(historicalMonths.values)
        guard !spends.isEmpty else { return 0 }
        return spends.reduce(0, +) / Double(spends.count)
    }

    private static func compareTrend(thisMonth: Double, average: Double) -> SpendingTrend {
        let tolerance = max(average, thisMonth) * 0.05
        let diff = thisMonth - average

        if abs(diff) <= tolerance {
            return .same
        } else if diff > 0 {
            return .higher
        } else {
            return .lower
        }
    }
}
