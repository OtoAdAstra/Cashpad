//
//  ThemeManager.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 23.01.26.
//

import SwiftUI
import Combine

protocol ThemeManagerProtocol: AnyObject {
    var theme: AppTheme { get set }
    var onThemeChange: ((AppTheme) -> Void)? { get set }
}

final class ThemeManager: ThemeManagerProtocol {

    @AppStorage("appTheme")
    private var storedTheme: String = AppTheme.system.rawValue

    var onThemeChange: ((AppTheme) -> Void)?

    var theme: AppTheme {
        get {
            AppTheme(rawValue: storedTheme) ?? .system
        }
        set {
            storedTheme = newValue.rawValue
            onThemeChange?(newValue)
        }
    }
}
