//
//  SpendingTrendTests.swift
//  CashpadTests
//

import Testing
import SwiftUI
@testable import Cashpad

struct SpendingTrendTests {

    @Test func higherSymbolName() {
        #expect(SpendingTrend.higher.symbolName == "chart.line.downtrend.xyaxis")
    }

    @Test func lowerSymbolName() {
        #expect(SpendingTrend.lower.symbolName == "chart.line.uptrend.xyaxis")
    }

    @Test func sameSymbolName() {
        #expect(SpendingTrend.same.symbolName == "chart.line.flattrend.xyaxis")
    }

    @Test func higherColor() {
        #expect(SpendingTrend.higher.color == .red)
    }

    @Test func lowerColor() {
        #expect(SpendingTrend.lower.color == .green)
    }

    @Test func sameColor() {
        #expect(SpendingTrend.same.color == .yellow)
    }
}
