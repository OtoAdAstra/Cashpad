//
//  MockAccountRepository.swift
//  CashpadTests
//

import CoreData
@testable import Cashpad

final class MockAccountRepository: AccountRepositoryProtocol {

    // MARK: - Stubbed results
    var stubbedAccounts: [Account] = []
    var stubbedAccount: Account?
    var stubbedCreatedAccount: Account?
    var shouldThrow: Error?
    var deleteAllCalled = false
    var deletedAccount: Account?
    var addedInitialTransactionAccount: Account?
    var addedInitialTransactionAmount: Double?

    func fetchAccounts() throws -> [Account] {
        if let error = shouldThrow { throw error }
        return stubbedAccounts
    }

    func fetchAccount(by id: UUID) throws -> Account {
        if let error = shouldThrow { throw error }
        guard let account = stubbedAccount ?? stubbedAccounts.first(where: { $0.id == id }) else {
            throw AccountRepositoryError.accountNotFound(id: id)
        }
        return account
    }

    func createAccount(
        name: String,
        currency: String,
        emoji: String?,
        color: String?
    ) throws -> Account {
        if let error = shouldThrow { throw error }
        guard let account = stubbedCreatedAccount else {
            fatalError("stubbedCreatedAccount not set")
        }
        return account
    }

    func deleteAccount(_ account: Account) throws {
        if let error = shouldThrow { throw error }
        deletedAccount = account
    }

    func addInitialTransaction(to account: Account, amount: Double) throws {
        if let error = shouldThrow { throw error }
        addedInitialTransactionAccount = account
        addedInitialTransactionAmount = amount
    }

    func deleteAllAccounts() throws {
        if let error = shouldThrow { throw error }
        deleteAllCalled = true
    }
}
