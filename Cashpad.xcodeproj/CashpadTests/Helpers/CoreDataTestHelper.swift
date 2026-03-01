//
//  CoreDataTestHelper.swift
//  CashpadTests
//

import CoreData
@testable import Cashpad

enum CoreDataTestHelper {

    /// Creates an in-memory NSPersistentContainer for testing.
    static func makeInMemoryContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "Cashpad")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load in-memory store: \(error)")
            }
        }
        return container
    }

    /// Creates an Account entity in the given context.
    @discardableResult
    static func makeAccount(
        in context: NSManagedObjectContext,
        id: UUID = UUID(),
        name: String = "Test",
        currency: String = "USD",
        emoji: String = "💰",
        color: String = "blue",
        createdAt: Date = Date()
    ) -> Account {
        let account = Account(context: context)
        account.id = id
        account.name = name
        account.currency = currency
        account.emoji = emoji
        account.color = color
        account.createdAt = createdAt
        return account
    }

    /// Creates a Transaction entity in the given context.
    @discardableResult
    static func makeTransaction(
        in context: NSManagedObjectContext,
        account: Account,
        id: UUID = UUID(),
        amount: Double = 100.0,
        date: Date = Date(),
        note: String? = nil,
        type: TransactionType = .income
    ) -> Transaction {
        let transaction = Transaction(context: context)
        transaction.id = id
        transaction.amount = amount
        transaction.date = date
        transaction.note = note
        transaction.type = type.storedValue
        transaction.account = account
        return transaction
    }
}
