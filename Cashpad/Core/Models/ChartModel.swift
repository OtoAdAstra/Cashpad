//
//  ChartModel.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 20.01.26.
//

enum Flow: String, CaseIterable, Identifiable {
    case income = "Income"
    case expense = "Expense"
    var id: String { rawValue }
}
enum Granularity: String, CaseIterable, Identifiable {
    case day = "Day"
    case week = "Week"
    case year = "Year"
    var id: String { rawValue }
}
