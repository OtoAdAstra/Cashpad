//
//  TransactionFilterTests.swift
//  CashpadTests
//

import Testing
import Foundation
@testable import Cashpad

struct TransactionFilterTests {

    @Test func emptyFilterIsEmpty() {
        let filter = TransactionFilter.empty
        #expect(filter.isEmpty)
    }

    @Test func defaultInitIsEmpty() {
        let filter = TransactionFilter()
        #expect(filter.isEmpty)
    }

    @Test func filterWithStartDateIsNotEmpty() {
        let filter = TransactionFilter(startDate: Date())
        #expect(!filter.isEmpty)
    }

    @Test func filterWithEndDateIsNotEmpty() {
        let filter = TransactionFilter(endDate: Date())
        #expect(!filter.isEmpty)
    }

    @Test func filterWithMinAmountIsNotEmpty() {
        let filter = TransactionFilter(minAmount: 10.0)
        #expect(!filter.isEmpty)
    }

    @Test func filterWithMaxAmountIsNotEmpty() {
        let filter = TransactionFilter(maxAmount: 100.0)
        #expect(!filter.isEmpty)
    }

    @Test func filterWithAllFieldsIsNotEmpty() {
        let filter = TransactionFilter(
            startDate: Date(),
            endDate: Date(),
            minAmount: 0,
            maxAmount: 1000
        )
        #expect(!filter.isEmpty)
    }
}
