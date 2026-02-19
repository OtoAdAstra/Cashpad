//
//  AccountColor.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 13.01.26.
//


import SwiftUI

enum AccountColor: String, CaseIterable, Identifiable {
    case blue
    case purple
    case pink
    case red
    case orange
    case yellow
    case green
    case cyan
    case indigo
    case gray

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .blue: return .blue
        case .purple: return .purple
        case .pink: return .pink
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .green: return .green
        case .cyan: return .cyan
        case .indigo: return .indigo
        case .gray: return .gray
        }
    }
}