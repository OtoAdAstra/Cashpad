//
//  AccountRepoistory.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 12.01.26.
//

import CoreData

protocol AccountRepositoryProtocol {
    func fetchAccounts() throws -> [Account]
    func fetchAccount(by id: UUID) throws -> Account
    func createAccount(
        name: String,
        currency: String,
        emoji: String?,
        color: String?
    ) throws -> Account
    func deleteAccount(_ account: Account) throws
    func addInitialTransaction(
        to account: Account,
        amount: Double
    ) throws
    func deleteAllAccounts() throws
}

final class AccountRepository: AccountRepositoryProtocol {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAccounts() throws -> [Account] {
        let request: NSFetchRequest<Account> = Account.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: true)
        ]
        return try context.fetch(request)
    }
    
    func fetchAccount(by id: UUID) throws -> Account {
        let request: NSFetchRequest<Account> = Account.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1

        guard let account = try context.fetch(request).first else {
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
        let account = Account(context: context)
        account.id = UUID()
        account.name = name
        account.currency = currency
        account.emoji = emoji
        account.color = color
        account.createdAt = Date()

        try context.save()
        return account
    }
    
    func addInitialTransaction(
        to account: Account,
        amount: Double
    ) throws {
        let transaction = Transaction(context: context)
        transaction.id = UUID()
        transaction.amount = amount
        transaction.date = Date()
        transaction.type = 0
        transaction.account = account

        try context.save()
    }
    
    func deleteAccount(_ account: Account) throws {
        context.delete(account)
        try context.save()
    }
    
    func deleteAllAccounts() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> =
            Account.fetchRequest()

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs

        let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
        let objectIDs = result?.result as? [NSManagedObjectID] ?? []

        let changes: [AnyHashable: Any] = [
            NSDeletedObjectsKey: objectIDs
        ]

        NSManagedObjectContext.mergeChanges(
            fromRemoteContextSave: changes,
            into: [context]
        )
    }
}

