//
//  ExchangeRateRepositoryProtocol.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 22.01.26.
//

import Foundation

protocol ExchangeRepositoryProtocol {
    func getLatestRates(base: String) async throws -> ExchangeRate
}

final class ExchangeRepository: ExchangeRepositoryProtocol {

    private let service: ExchangeServiceProtocol
    private let cache: ExchangeRateCacheProtocol
    private let cacheTTL: TimeInterval = 6 * 60 * 60

    init(service: ExchangeServiceProtocol, cache: ExchangeRateCacheProtocol) {
        self.service = service
        self.cache = cache
    }

    func getLatestRates(base: String) async throws -> ExchangeRate {

        if let cached = cache.load(for: base),
           Date().timeIntervalSince(cached.fetchedAt) < cacheTTL {
            return cached
        }

        do {
            let fresh = try await service.fetchLatestRates(base: base)
            cache.save(fresh)
            return fresh
        } catch {
            if let stale = cache.load(for: base) {
                return stale
            }
            throw error
        }
    }
}
