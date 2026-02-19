//
//  ExchangeViewModel.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 22.01.26.
//

import Foundation
import Combine

@MainActor
final class ExchangeViewModel {

    // MARK: - Input
    @Published var fromCurrency: String = "USD"
    @Published var toCurrency: String = "EUR"
    @Published var amount: Double? = 1

    // MARK: - Output
    @Published private(set) var convertedAmount: Double? = nil
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var error: String?
    @Published private(set) var availableCurrencies: [String] = []

    // MARK: - Dependencies
    private let repository: ExchangeRepositoryProtocol
    private var exchangeRate: ExchangeRate?
    private var cancellables = Set<AnyCancellable>()
    private var isRatesLoaded = false

    init(repository: ExchangeRepositoryProtocol) {
        self.repository = repository
        bind()
    }

    func loadRates() {
        isLoading = true
        error = nil

        Task {
            do {
                let rate = try await repository.getLatestRates(base: "USD")
                self.exchangeRate = rate
                self.availableCurrencies = rate.rates.keys.sorted()
                self.isRatesLoaded = true
                self.recalculate()
                self.isLoading = false
            } catch {
                self.error = error.localizedDescription
                self.isLoading = false
            }
        }
    }

    private func bind() {
        Publishers.CombineLatest3($fromCurrency, $toCurrency, $amount)
            .receive(on: RunLoop.main)
            .debounce(for: .milliseconds(0),
                      scheduler: RunLoop.main)
            .sink { [weak self] _, _, _ in
                self?.recalculate()
            }
            .store(in: &cancellables)
    }

    private func recalculate() {
        guard
            isRatesLoaded,
            let exchangeRate,
            let amount
        else {
            convertedAmount = nil
            return
        }

        convertedAmount = exchangeRate.convert(
            amount: amount,
            from: fromCurrency,
            to: toCurrency
        )
    }}
