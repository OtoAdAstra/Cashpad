//
//  AccountRepositoryErrorTests.swift
//  CashpadTests
//

import Testing
import Foundation
@testable import Cashpad

struct AccountRepositoryErrorTests {

    @Test func errorDescriptionContainsId() {
        let id = UUID()
        let error = AccountRepositoryError.accountNotFound(id: id)
        #expect(error.errorDescription?.contains(id.uuidString) == true)
    }

    @Test func errorDescriptionFormat() {
        let id = UUID()
        let error = AccountRepositoryError.accountNotFound(id: id)
        #expect(error.errorDescription == "Error not found account with id: \(id)")
    }
}
