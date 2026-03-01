//
//  AppThemeTests.swift
//  CashpadTests
//

import Testing
import SwiftUI
@testable import Cashpad

struct AppThemeTests {

    @Test func titles() {
        #expect(AppTheme.system.title == "System")
        #expect(AppTheme.light.title == "Light")
        #expect(AppTheme.dark.title == "Dark")
    }

    @Test func icons() {
        #expect(AppTheme.system.icon == "gearshape")
        #expect(AppTheme.light.icon == "sun.max")
        #expect(AppTheme.dark.icon == "moon")
    }

    @Test func colorSchemes() {
        #expect(AppTheme.system.colorScheme == nil)
        #expect(AppTheme.light.colorScheme == .light)
        #expect(AppTheme.dark.colorScheme == .dark)
    }

    @Test func rawValues() {
        #expect(AppTheme.system.rawValue == "system")
        #expect(AppTheme.light.rawValue == "light")
        #expect(AppTheme.dark.rawValue == "dark")
    }

    @Test func identifiableIds() {
        for theme in AppTheme.allCases {
            #expect(theme.id == theme.rawValue)
        }
    }

    @Test func allCasesCount() {
        #expect(AppTheme.allCases.count == 3)
    }
}
