//
//  ExchangeRateCache.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 21.01.26.
//

import Foundation

// MARK: - Codable snapshot stored on disk

private struct ExchangeRateSnapshot: Codable {
    let base: String
    let rates: [String: Double]
    let fetchedAt: Date
}

// MARK: - Protocol

protocol ExchangeRateCacheProtocol {
    func load(for base: String) -> ExchangeRate?
    func save(_ rate: ExchangeRate)
}

// MARK: - UserDefaults-backed implementation

final class ExchangeRateCache: ExchangeRateCacheProtocol {

    private let defaults: UserDefaults
    private let key = "com.cashpad.exchangeRateCache"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load(for base: String) -> ExchangeRate? {
        guard
            let data = defaults.data(forKey: key),
            let snapshot = try? decoder.decode(ExchangeRateSnapshot.self, from: data),
            snapshot.base == base
        else { return nil }

        return ExchangeRate(
            base: snapshot.base,
            rates: snapshot.rates,
            fetchedAt: snapshot.fetchedAt
        )
    }

    func save(_ rate: ExchangeRate) {
        let snapshot = ExchangeRateSnapshot(
            base: rate.base,
            rates: rate.rates,
            fetchedAt: rate.fetchedAt
        )
        guard let data = try? encoder.encode(snapshot) else { return }
        defaults.set(data, forKey: key)
    }
}
