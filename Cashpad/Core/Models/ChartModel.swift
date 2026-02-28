//
//  ChartModel.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 20.01.26.
//

enum Granularity: String, CaseIterable, Identifiable {
    case day = "Day"
    case week = "Week"
    case year = "Year"
    var id: String { rawValue }
}
