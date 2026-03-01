//
//  CurrencyTests.swift
//  CashpadTests
//

import Testing
@testable import Cashpad

struct CurrencyTests {

    @Test func usdSymbol() {
        #expect(Currency.usd.symbol == "$")
    }

    @Test func chfSymbol() {
        #expect(Currency.chf.symbol == "₣")
    }

    @Test func eurSymbol() {
        #expect(Currency.eur.symbol == "€")
    }

    @Test func gbpSymbol() {
        #expect(Currency.gbp.symbol == "£")
    }

    @Test func rawValues() {
        #expect(Currency.usd.rawValue == "USD")
        #expect(Currency.chf.rawValue == "CHF")
        #expect(Currency.eur.rawValue == "EUR")
        #expect(Currency.gbp.rawValue == "GBP")
    }

    @Test func identifiableIds() {
        for currency in Currency.allCases {
            #expect(currency.id == currency.rawValue)
        }
    }

    @Test func allCasesCount() {
        #expect(Currency.allCases.count == 4)
    }
}
