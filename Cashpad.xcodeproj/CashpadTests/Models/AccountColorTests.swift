//
//  AccountColorTests.swift
//  CashpadTests
//

import Testing
import SwiftUI
@testable import Cashpad

struct AccountColorTests {

    @Test func allCasesCount() {
        #expect(AccountColor.allCases.count == 10)
    }

    @Test func identifiableIds() {
        for color in AccountColor.allCases {
            #expect(color.id == color.rawValue)
        }
    }

    @Test func colorMapping() {
        #expect(AccountColor.blue.color == .blue)
        #expect(AccountColor.purple.color == .purple)
        #expect(AccountColor.pink.color == .pink)
        #expect(AccountColor.red.color == .red)
        #expect(AccountColor.orange.color == .orange)
        #expect(AccountColor.yellow.color == .yellow)
        #expect(AccountColor.green.color == .green)
        #expect(AccountColor.cyan.color == .cyan)
        #expect(AccountColor.indigo.color == .indigo)
        #expect(AccountColor.gray.color == .gray)
    }
}
