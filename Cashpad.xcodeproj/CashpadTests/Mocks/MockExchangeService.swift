//
//  MockExchangeService.swift
//  CashpadTests
//

import Foundation
@testable import Cashpad

final class MockExchangeService: ExchangeServiceProtocol {

    var stubbedRate: ExchangeRate?
    var shouldThrow: Error?
    var fetchCallCount = 0

    func fetchLatestRates(base: String) async throws -> ExchangeRate {
        fetchCallCount += 1
        if let error = shouldThrow { throw error }
        guard let rate = stubbedRate else {
            throw URLError(.badServerResponse)
        }
        return rate
    }
}
