//
//  AccountModelTests.swift
//  CashpadTests
//

import Testing
import Foundation
@testable import Cashpad

struct AccountModelTests {

    @Test func initSetsAllProperties() {
        let id = UUID()
        let date = Date()
        let model = AccountModel(
            id: id,
            name: "Savings",
            currency: "USD",
            emoji: "💰",
            color: "blue",
            createdAt: date,
            balance: 1500.50
        )

        #expect(model.id == id)
        #expect(model.name == "Savings")
        #expect(model.currency == "USD")
        #expect(model.emoji == "💰")
        #expect(model.color == "blue")
        #expect(model.createdAt == date)
        #expect(model.balance == 1500.50)
    }

    @Test func hashable() {
        let id = UUID()
        let date = Date()
        let model1 = AccountModel(id: id, name: "A", currency: "USD", emoji: nil, color: nil, createdAt: date, balance: 0)
        let model2 = AccountModel(id: id, name: "A", currency: "USD", emoji: nil, color: nil, createdAt: date, balance: 0)
        #expect(model1 == model2)
    }

    @Test func optionalFieldsCanBeNil() {
        let model = AccountModel(
            id: UUID(),
            name: "Test",
            currency: "EUR",
            emoji: nil,
            color: nil,
            createdAt: Date(),
            balance: 0
        )
        #expect(model.emoji == nil)
        #expect(model.color == nil)
    }
}
