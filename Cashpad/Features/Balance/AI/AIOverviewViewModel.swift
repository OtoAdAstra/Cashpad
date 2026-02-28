//
//  AIOverviewViewModel.swift
//  Cashpad
//

import Foundation
import FoundationModels
import Combine

@MainActor
final class AIOverviewViewModel: ObservableObject {

    @Published private(set) var overviewText: String = ""
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isUnavailable: Bool = false
    @Published private(set) var errorMessage: String?

    private let model = SystemLanguageModel.default

    func generate(
        accountName: String,
        currency: String,
        balance: Double,
        transactions: [Transaction]
    ) async {
        guard case .available = model.availability else {
            isUnavailable = true
            return
        }

        isLoading = true
        overviewText = ""
        errorMessage = nil

        let prompt = buildPrompt(
            accountName: accountName,
            currency: currency,
            balance: balance,
            transactions: transactions
        )

        let session = LanguageModelSession(instructions: """
            You are a concise personal finance assistant inside a budgeting app.
            Summarize the user's account activity in plain, friendly English.
            Mention the current balance, recent income vs. expenses, and any notable patterns.
            Keep the response under 80 words. Do not use bullet points or headers.
            """)

        do {
            let response = try await session.respond(to: prompt)
            overviewText = response.content
        } catch {
            errorMessage = "Could not generate overview: \(error.localizedDescription)"
        }

        isLoading = false
    }

    private func buildPrompt(
        accountName: String,
        currency: String,
        balance: Double,
        transactions: [Transaction]
    ) -> String {
        let recentTransactions = transactions
            .sorted { ($0.date ?? .distantPast) > ($1.date ?? .distantPast) }
            .prefix(20)

        let txLines = recentTransactions.map { tx -> String in
            let amount = String(format: "%.2f", tx.amount)
            let note = tx.note.flatMap { $0.isEmpty ? nil : $0 } ?? (tx.amount >= 0 ? "income" : "expense")
            return "\(amount) \(currency) – \(note)"
        }.joined(separator: "\n")

        return """
        Account: \(accountName)
        Currency: \(currency)
        Current balance: \(String(format: "%.2f", balance)) \(currency)

        Recent transactions (newest first):
        \(txLines.isEmpty ? "No transactions yet." : txLines)

        Please give a brief financial overview.
        """
    }
}
