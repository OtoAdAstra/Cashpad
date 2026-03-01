//
//  ExchangeRateTests.swift
//  CashpadTests
//

import Testing
import Foundation
@testable import Cashpad

struct ExchangeRateTests {

    private func makeSampleRate() -> ExchangeRate {
        ExchangeRate(
            base: "USD",
            rates: [
                "USD": 1.0,
                "EUR": 0.85,
                "GBP": 0.73,
                "CHF": 0.92
            ],
            fetchedAt: Date()
        )
    }

    @Test func convertSameCurrencyReturnsOriginalAmount() {
        let rate = makeSampleRate()
        let result = rate.convert(amount: 100.0, from: "USD", to: "USD")
        #expect(result == 100.0)
    }

    @Test func convertUSDToEUR() {
        let rate = makeSampleRate()
        let result = rate.convert(amount: 100.0, from: "USD", to: "EUR")
        // 100 / 1.0 * 0.85 = 85.0
        #expect(result == 85.0)
    }

    @Test func convertEURToGBP() {
        let rate = makeSampleRate()
        let result = rate.convert(amount: 100.0, from: "EUR", to: "GBP")
        // 100 / 0.85 * 0.73 ≈ 85.88
        let expected = (100.0 / 0.85) * 0.73
        #expect(abs(result - expected) < 0.01)
    }

    @Test func convertWithMissingSourceReturnsOriginal() {
        let rate = makeSampleRate()
        let result = rate.convert(amount: 50.0, from: "JPY", to: "EUR")
        #expect(result == 50.0)
    }

    @Test func convertWithMissingTargetReturnsOriginal() {
        let rate = makeSampleRate()
        let result = rate.convert(amount: 50.0, from: "USD", to: "JPY")
        #expect(result == 50.0)
    }

    @Test func convertZeroAmount() {
        let rate = makeSampleRate()
        let result = rate.convert(amount: 0.0, from: "USD", to: "EUR")
        #expect(result == 0.0)
    }

    @Test func convertNegativeAmount() {
        let rate = makeSampleRate()
        let result = rate.convert(amount: -100.0, from: "USD", to: "EUR")
        #expect(result == -85.0)
    }
}
