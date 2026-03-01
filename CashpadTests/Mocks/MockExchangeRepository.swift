//
//  MockExchangeRepository.swift
//  CashpadTests
//

import Foundation
@testable import Cashpad

final class MockExchangeRepository: ExchangeRepositoryProtocol {

    var stubbedRate: ExchangeRate?
    var shouldThrow: Error?

    func getLatestRates(base: String) async throws -> ExchangeRate {
        if let error = shouldThrow { throw error }
        guard let rate = stubbedRate else {
            throw URLError(.badServerResponse)
        }
        return rate
    }
}
