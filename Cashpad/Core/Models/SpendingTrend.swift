//
//  SpendingTrend.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 10.01.26.
//


import SwiftUI

enum SpendingTrend {
    case higher
    case lower
    case same

    var symbolName: String {
        switch self {
        case .higher:
            return "chart.line.downtrend.xyaxis"
        case .lower:
            return "chart.line.uptrend.xyaxis"
        case .same:
            return "chart.line.flattrend.xyaxis"
        }
    }

    var color: Color {
        switch self {
        case .higher:
            return .red
        case .lower:
            return .green
        case .same:
            return .yellow
        }
    }
}
