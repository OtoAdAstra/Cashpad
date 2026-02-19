//
//  BalanceFormatter.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 16.01.26.
//


import Foundation

enum BalanceFormatter {

    static func format(_ value: Double) -> String {
        String(format: "%.2f", value)
    }
}