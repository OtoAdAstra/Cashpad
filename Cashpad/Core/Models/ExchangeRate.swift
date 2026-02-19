//
//  ExchangeRate.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 21.01.26.
//

import Foundation

struct ExchangeRate {
    let base: String
    let rates: [String: Double]
    let fetchedAt: Date
    
    func convert(
        amount: Double,
        from source: String,
        to target: String
    ) -> Double {
        
        if source == target {
            return amount
        }
        
        guard
            let sourceRate = rates[source],
            let targetRate = rates[target]
        else {
            return amount
        }
        
        let baseAmount = amount / sourceRate
        return baseAmount * targetRate
    }
}
