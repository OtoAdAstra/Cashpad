//
//  AccountIcon.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 13.01.26.
//


import SwiftUI

enum AccountIcon: String, CaseIterable, Identifiable {
    case creditCard = "creditcard"
    case wallet = "wallet.pass"
    case bank = "building.columns"
    case cash = "banknote"
    case chart = "chart.pie"

    var id: String { rawValue }
}
