//
//  MockTransactionRepository.swift
//  CashpadTests
//

import CoreData
@testable import Cashpad

final class MockTransactionRepository: TransactionRepositoryProtocol {

    var stubbedTransactions: [Transaction] = []
    var createdTransactions: [Transaction] = []
    var deletedTransactions: [Transaction] = []
    var shouldThrow: Error?
    var stubbedCreatedTransaction: Transaction?

    func fetchTransactions(accountId: UUID) throws -> [Transaction] {
        if let error = shouldThrow { throw error }
        return stubbedTransactions
    }

    func createTransaction(
        account: Account,
        amount: Double,
        date: Date,
        note: String?,
        type: TransactionType
    ) throws -> Transaction {
        if let error = shouldThrow { throw error }
        guard let transaction = stubbedCreatedTransaction else {
            fatalError("stubbedCreatedTransaction not set")
        }
        return transaction
    }

    func deleteTransaction(_ transaction: Transaction) throws {
        if let error = shouldThrow { throw error }
        deletedTransactions.append(transaction)
    }
}
