//
//  TransactionType.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 19.01.26.
//


enum TransactionType: String, CaseIterable, Identifiable {
    case income = "Income"
    case expense = "Expense"

    var id: String { rawValue }

    var storedValue: Int16 {
        switch self {
        case .income:  return 0
        case .expense: return 1
        }
    }

    /// Initializes from the Core Data stored integer.
    init(storedValue: Int16) {
        switch storedValue {
        case 0:  self = .income
        default: self = .expense
        }
    }
}

