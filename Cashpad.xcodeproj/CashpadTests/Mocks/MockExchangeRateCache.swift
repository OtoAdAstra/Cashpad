//
//  MockExchangeRateCache.swift
//  CashpadTests
//

import Foundation
@testable import Cashpad

final class MockExchangeRateCache: ExchangeRateCacheProtocol {

    var storedRate: ExchangeRate?
    var saveCallCount = 0
    var loadCallCount = 0

    func load(for base: String) -> ExchangeRate? {
        loadCallCount += 1
        guard let rate = storedRate, rate.base == base else { return nil }
        return rate
    }

    func save(_ rate: ExchangeRate) {
        saveCallCount += 1
        storedRate = rate
    }
}
