//
//  TransactionTypeTests.swift
//  CashpadTests
//

import Testing
@testable import Cashpad

struct TransactionTypeTests {

    @Test func storedValueForIncome() {
        #expect(TransactionType.income.storedValue == 0)
    }

    @Test func storedValueForExpense() {
        #expect(TransactionType.expense.storedValue == 1)
    }

    @Test func initFromStoredValueZero() {
        let type = TransactionType(storedValue: 0)
        #expect(type == .income)
    }

    @Test func initFromStoredValueOne() {
        let type = TransactionType(storedValue: 1)
        #expect(type == .expense)
    }

    @Test func initFromUnknownStoredValueDefaultsToExpense() {
        let type = TransactionType(storedValue: 99)
        #expect(type == .expense)
    }

    @Test func rawValues() {
        #expect(TransactionType.income.rawValue == "Income")
        #expect(TransactionType.expense.rawValue == "Expense")
    }

    @Test func identifiableIds() {
        #expect(TransactionType.income.id == "Income")
        #expect(TransactionType.expense.id == "Expense")
    }

    @Test func roundTripConversion() {
        for type in TransactionType.allCases {
            let restored = TransactionType(storedValue: type.storedValue)
            #expect(restored == type)
        }
    }
}
