//
//  Currency.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 13.01.26.
//


enum Currency: String, CaseIterable, Identifiable {
    case usd = "USD"
    case chf = "CHF"
    case eur = "EUR"
    case gbp = "GBP"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .usd: return "$"
        case .chf: return "₣"
        case .eur: return "€"
        case .gbp: return "£"
        }
    }
}
