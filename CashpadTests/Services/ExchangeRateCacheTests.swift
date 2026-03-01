//
//  ExchangeRateCacheTests.swift
//  CashpadTests
//

import Testing
import Foundation
@testable import Cashpad

struct ExchangeRateCacheTests {

    private func makeSUT() -> (cache: ExchangeRateCache, defaults: UserDefaults) {
        let defaults = UserDefaults(suiteName: "ExchangeRateCacheTests_\(UUID().uuidString)")!
        let cache = ExchangeRateCache(defaults: defaults)
        return (cache, defaults)
    }

    private func makeSampleRate(base: String = "USD") -> ExchangeRate {
        ExchangeRate(
            base: base,
            rates: ["USD": 1.0, "EUR": 0.85],
            fetchedAt: Date()
        )
    }

    @Test func saveAndLoad() {
        let (cache, _) = makeSUT()
        let rate = makeSampleRate()

        cache.save(rate)
        let loaded = cache.load(for: "USD")

        #expect(loaded != nil)
        #expect(loaded?.base == "USD")
        #expect(loaded?.rates["EUR"] == 0.85)
    }

    @Test func loadReturnsNilForMismatchedBase() {
        let (cache, _) = makeSUT()
        let rate = makeSampleRate(base: "USD")

        cache.save(rate)
        let loaded = cache.load(for: "EUR")

        #expect(loaded == nil)
    }

    @Test func loadReturnsNilWhenEmpty() {
        let (cache, _) = makeSUT()
        let loaded = cache.load(for: "USD")
        #expect(loaded == nil)
    }

    @Test func saveOverwritesPrevious() {
        let (cache, _) = makeSUT()
        let rate1 = ExchangeRate(base: "USD", rates: ["EUR": 0.85], fetchedAt: Date())
        let rate2 = ExchangeRate(base: "USD", rates: ["EUR": 0.90], fetchedAt: Date())

        cache.save(rate1)
        cache.save(rate2)

        let loaded = cache.load(for: "USD")
        #expect(loaded?.rates["EUR"] == 0.90)
    }

    @Test func preservesFetchedAt() {
        let (cache, _) = makeSUT()
        let fetchedAt = Date(timeIntervalSince1970: 1700000000)
        let rate = ExchangeRate(base: "USD", rates: ["EUR": 0.85], fetchedAt: fetchedAt)

        cache.save(rate)
        let loaded = cache.load(for: "USD")

        #expect(loaded?.fetchedAt == fetchedAt)
    }
}
