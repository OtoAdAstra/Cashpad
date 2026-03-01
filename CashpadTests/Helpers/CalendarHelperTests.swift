//
//  CalendarHelperTests.swift
//  CashpadTests
//

import Testing
import Foundation
@testable import Cashpad

struct CalendarHelperTests {

    private var calendar: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        cal.firstWeekday = 1 // Sunday
        return cal
    }

    @Test func dayGranularitySpansOneDay() {
        let cal = calendar
        let date = cal.date(from: DateComponents(year: 2025, month: 6, day: 15, hour: 14))!
        let range = cal.periodRange(for: .day, anchoredAt: date)

        let startComps = cal.dateComponents([.year, .month, .day, .hour], from: range.lowerBound)
        #expect(startComps.year == 2025)
        #expect(startComps.month == 6)
        #expect(startComps.day == 15)
        #expect(startComps.hour == 0)

        let endComps = cal.dateComponents([.year, .month, .day, .hour], from: range.upperBound)
        #expect(endComps.year == 2025)
        #expect(endComps.month == 6)
        #expect(endComps.day == 16)
        #expect(endComps.hour == 0)
    }

    @Test func weekGranularitySpansSevenDays() {
        let cal = calendar
        let date = cal.date(from: DateComponents(year: 2025, month: 6, day: 18))! // Wednesday
        let range = cal.periodRange(for: .week, anchoredAt: date)

        let diff = cal.dateComponents([.day], from: range.lowerBound, to: range.upperBound)
        #expect(diff.day == 7)
    }

    @Test func yearGranularitySpansFullYear() {
        let cal = calendar
        let date = cal.date(from: DateComponents(year: 2025, month: 6, day: 15))!
        let range = cal.periodRange(for: .year, anchoredAt: date)

        let startComps = cal.dateComponents([.year, .month, .day], from: range.lowerBound)
        #expect(startComps.year == 2025)
        #expect(startComps.month == 1)
        #expect(startComps.day == 1)

        let endComps = cal.dateComponents([.year, .month, .day], from: range.upperBound)
        #expect(endComps.year == 2026)
        #expect(endComps.month == 1)
        #expect(endComps.day == 1)
    }

    @Test func dayRangeContainsAnchorDate() {
        let cal = calendar
        let date = cal.date(from: DateComponents(year: 2025, month: 3, day: 10, hour: 15))!
        let range = cal.periodRange(for: .day, anchoredAt: date)
        #expect(range.contains(date))
    }

    @Test func weekRangeContainsAnchorDate() {
        let cal = calendar
        let date = cal.date(from: DateComponents(year: 2025, month: 3, day: 12))!
        let range = cal.periodRange(for: .week, anchoredAt: date)
        #expect(range.contains(date))
    }

    @Test func yearRangeContainsAnchorDate() {
        let cal = calendar
        let date = cal.date(from: DateComponents(year: 2025, month: 7, day: 4))!
        let range = cal.periodRange(for: .year, anchoredAt: date)
        #expect(range.contains(date))
    }
}
