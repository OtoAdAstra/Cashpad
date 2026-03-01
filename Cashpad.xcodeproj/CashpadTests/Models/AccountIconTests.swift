//
//  AccountIconTests.swift
//  CashpadTests
//

import Testing
@testable import Cashpad

struct AccountIconTests {

    @Test func allCasesCount() {
        #expect(AccountIcon.allCases.count == 5)
    }

    @Test func rawValues() {
        #expect(AccountIcon.creditCard.rawValue == "creditcard")
        #expect(AccountIcon.wallet.rawValue == "wallet.pass")
        #expect(AccountIcon.bank.rawValue == "building.columns")
        #expect(AccountIcon.cash.rawValue == "banknote")
        #expect(AccountIcon.chart.rawValue == "chart.pie")
    }

    @Test func identifiableIds() {
        for icon in AccountIcon.allCases {
            #expect(icon.id == icon.rawValue)
        }
    }
}
