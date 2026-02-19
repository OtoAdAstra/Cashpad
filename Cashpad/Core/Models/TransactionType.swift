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
}

