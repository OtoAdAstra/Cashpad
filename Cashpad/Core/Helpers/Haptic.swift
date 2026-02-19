//
//  Haptic.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 25.01.26.
//

import UIKit

enum Haptic {
    static func tap() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}
