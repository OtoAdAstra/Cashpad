//
//  ThemeHelper.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 23.01.26.
//

import UIKit

func applyTheme(_ theme: AppTheme, to window: UIWindow) {
    switch theme {
    case .system:
        window.overrideUserInterfaceStyle = .unspecified
    case .light:
        window.overrideUserInterfaceStyle = .light
    case .dark:
        window.overrideUserInterfaceStyle = .dark
    }
}
