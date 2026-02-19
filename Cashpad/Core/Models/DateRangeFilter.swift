//
//  DateRangeFilter.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 24.01.26.
//

import Foundation


enum DateRangeFilter: String, CaseIterable, Identifiable {
    case all, today, week, month

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all: "All"
        case .today: "Today"
        case .week: "Week"
        case .month: "Month"
        }
    }
}
