//
//  SpendingTrendCalculatorTests.swift
//  CashpadTests
//

import Testing
import CoreData
import Foundation
@testable import Cashpad

struct SpendingTrendCalculatorTests {

    private func makeContext() -> NSManagedObjectContext {
        CoreDataTestHelper.makeInMemoryContainer().viewContext
    }

    @Test func emptyTransactionsReturnsSame() {
        let result = SpendingTrendCalculator.trend(for: Set<Transaction>())
        #expect(result == .same)
    }

    @Test func onlyIncomeTransactionsReturnsSame() {
        let context = makeContext()
        let account = CoreDataTestHelper.makeAccount(in: context)

        let tx = CoreDataTestHelper.makeTransaction(
            in: context,
            account: account,
            amount: 100.0,
            type: .income
        )

        let result = SpendingTrendCalculator.trend(for: [tx])
        #expect(result == .same)
    }

    @Test func currentMonthHigherThanAverageReturnsHigher() {
        let context = makeContext()
        let account = CoreDataTestHelper.makeAccount(in: context)
        let calendar = Calendar.current

        // Historical: 3 months ago, $50 expense
        let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: Date())!
        let historicalTx = CoreDataTestHelper.makeTransaction(
            in: context,
            account: account,
            amount: -50.0,
            date: threeMonthsAgo,
            type: .expense
        )

        // Current month: $200 expense (much higher)
        let currentTx = CoreDataTestHelper.makeTransaction(
            in: context,
            account: account,
            amount: -200.0,
            date: Date(),
            type: .expense
        )

        let result = SpendingTrendCalculator.trend(for: [historicalTx, currentTx])
        #expect(result == .higher)
    }

    @Test func currentMonthLowerThanAverageReturnsLower() {
        let context = makeContext()
        let account = CoreDataTestHelper.makeAccount(in: context)
        let calendar = Calendar.current

        // Historical: 2 months ago, $500 expense
        let twoMonthsAgo = calendar.date(byAdding: .month, value: -2, to: Date())!
        let historicalTx = CoreDataTestHelper.makeTransaction(
            in: context,
            account: account,
            amount: -500.0,
            date: twoMonthsAgo,
            type: .expense
        )

        // Current month: $10 expense (much lower)
        let currentTx = CoreDataTestHelper.makeTransaction(
            in: context,
            account: account,
            amount: -10.0,
            date: Date(),
            type: .expense
        )

        let result = SpendingTrendCalculator.trend(for: [historicalTx, currentTx])
        #expect(result == .lower)
    }

    @Test func totalTrendAggregatesAllAccounts() {
        let context = makeContext()
        let account1 = CoreDataTestHelper.makeAccount(in: context, name: "Account1")
        let account2 = CoreDataTestHelper.makeAccount(in: context, name: "Account2")

        // Only income, no expenses
        CoreDataTestHelper.makeTransaction(
            in: context,
            account: account1,
            amount: 100.0,
            type: .income
        )
        CoreDataTestHelper.makeTransaction(
            in: context,
            account: account2,
            amount: 200.0,
            type: .income
        )

        let result = SpendingTrendCalculator.totalTrend(for: [account1, account2])
        #expect(result == .same)
    }

    @Test func trendsByAccountReturnsPerAccountTrends() {
        let context = makeContext()
        let id1 = UUID()
        let id2 = UUID()
        let account1 = CoreDataTestHelper.makeAccount(in: context, id: id1, name: "A1")
        let account2 = CoreDataTestHelper.makeAccount(in: context, id: id2, name: "A2")

        // Only income for both
        CoreDataTestHelper.makeTransaction(in: context, account: account1, amount: 100.0, type: .income)
        CoreDataTestHelper.makeTransaction(in: context, account: account2, amount: 200.0, type: .income)

        let trends = SpendingTrendCalculator.trendsByAccount(for: [account1, account2])

        #expect(trends[id1] == .same)
        #expect(trends[id2] == .same)
    }
}
