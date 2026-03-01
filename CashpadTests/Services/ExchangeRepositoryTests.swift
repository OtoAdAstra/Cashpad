//
//  ExchangeRepositoryTests.swift
//  CashpadTests
//

import Testing
import Foundation
@testable import Cashpad

struct ExchangeRepositoryTests {

    private func makeSUT() -> (
        repository: ExchangeRepository,
        service: MockExchangeService,
        cache: MockExchangeRateCache
    ) {
        let service = MockExchangeService()
        let cache = MockExchangeRateCache()
        let repository = ExchangeRepository(service: service, cache: cache)
        return (repository, service, cache)
    }

    private func makeFreshRate() -> ExchangeRate {
        ExchangeRate(
            base: "USD",
            rates: ["USD": 1.0, "EUR": 0.85],
            fetchedAt: Date()
        )
    }

    private func makeStaleRate() -> ExchangeRate {
        ExchangeRate(
            base: "USD",
            rates: ["USD": 1.0, "EUR": 0.80],
            fetchedAt: Date(timeIntervalSinceNow: -7 * 60 * 60) // 7 hours ago
        )
    }

    @Test func returnsCachedRateWhenFresh() async throws {
        let (repo, service, cache) = makeSUT()
        let freshRate = makeFreshRate()
        cache.storedRate = freshRate

        let result = try await repo.getLatestRates(base: "USD")

        #expect(result.rates["EUR"] == 0.85)
        #expect(service.fetchCallCount == 0)
    }

    @Test func fetchesFromServiceWhenCacheExpired() async throws {
        let (repo, service, cache) = makeSUT()
        cache.storedRate = makeStaleRate()

        let freshRate = makeFreshRate()
        service.stubbedRate = freshRate

        let result = try await repo.getLatestRates(base: "USD")

        #expect(service.fetchCallCount == 1)
        #expect(result.rates["EUR"] == 0.85)
        #expect(cache.saveCallCount == 1)
    }

    @Test func fetchesFromServiceWhenNoCachedData() async throws {
        let (repo, service, _) = makeSUT()
        service.stubbedRate = makeFreshRate()

        let result = try await repo.getLatestRates(base: "USD")

        #expect(service.fetchCallCount == 1)
        #expect(result.rates["EUR"] == 0.85)
    }

    @Test func fallsBackToStaleCacheOnServiceError() async throws {
        let (repo, service, cache) = makeSUT()
        let staleRate = makeStaleRate()
        cache.storedRate = staleRate
        service.shouldThrow = URLError(.notConnectedToInternet)

        let result = try await repo.getLatestRates(base: "USD")

        #expect(result.rates["EUR"] == 0.80)
    }

    @Test func throwsWhenServiceFailsAndNoCachedData() async {
        let (repo, service, _) = makeSUT()
        service.shouldThrow = URLError(.notConnectedToInternet)

        do {
            _ = try await repo.getLatestRates(base: "USD")
            Issue.record("Expected error to be thrown")
        } catch {
            // Expected
        }
    }

    @Test func savesNewRateToCache() async throws {
        let (repo, service, cache) = makeSUT()
        service.stubbedRate = makeFreshRate()

        _ = try await repo.getLatestRates(base: "USD")

        #expect(cache.saveCallCount == 1)
        #expect(cache.storedRate?.base == "USD")
    }
}
