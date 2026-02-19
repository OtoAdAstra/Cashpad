//
//  TransactionFilter.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 25.01.26.
//

import Foundation

struct TransactionFilter {
    var startDate: Date?
    var endDate: Date?
    var minAmount: Double?
    var maxAmount: Double?

    init(startDate: Date? = nil, endDate: Date? = nil, minAmount: Double? = nil, maxAmount: Double? = nil) {
        self.startDate = startDate
        self.endDate = endDate
        self.minAmount = minAmount
        self.maxAmount = maxAmount
    }

    static let empty = TransactionFilter()

    var isEmpty: Bool {
        return startDate == nil && endDate == nil && minAmount == nil && maxAmount == nil
    }
}
