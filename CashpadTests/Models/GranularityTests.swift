//
//  GranularityTests.swift
//  CashpadTests
//

import Testing
@testable import Cashpad

struct GranularityTests {

    @Test func rawValues() {
        #expect(Granularity.day.rawValue == "Day")
        #expect(Granularity.week.rawValue == "Week")
        #expect(Granularity.year.rawValue == "Year")
    }

    @Test func identifiableIds() {
        for granularity in Granularity.allCases {
            #expect(granularity.id == granularity.rawValue)
        }
    }

    @Test func allCasesCount() {
        #expect(Granularity.allCases.count == 3)
    }
}
