//
//  CalendarHelper.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 20.01.26.
//

import Foundation
import SwiftUI

extension Calendar {
    func periodRange(
        for granularity: Granularity,
        anchoredAt date: Date
    ) -> Range<Date> {
        switch granularity {
        case .day:
            let start = startOfDay(for: date)
            let end = self.date(byAdding: .day, value: 1, to: start)!
            return start..<end
        case .week:
            var comps = self.dateComponents(
                [.yearForWeekOfYear, .weekOfYear],
                from: date
            )
            comps.weekday = firstWeekday
            let start = self.date(from: comps) ?? startOfDay(for: date)
            let end = self.date(byAdding: .weekOfYear, value: 1, to: start)!
            return start..<end
        case .year:
            let comps = self.dateComponents([.year], from: date)
            let start = self.date(from: comps)!
            let end = self.date(byAdding: .year, value: 1, to: start)!
            return start..<end
        }
    }
}
