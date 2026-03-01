//
//  MockThemeManager.swift
//  CashpadTests
//

import Foundation
@testable import Cashpad

final class MockThemeManager: ThemeManagerProtocol {

    var theme: AppTheme = .system
    var onThemeChange: ((AppTheme) -> Void)?
}
