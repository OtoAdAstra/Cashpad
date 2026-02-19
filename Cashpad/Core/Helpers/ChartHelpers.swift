//
//  ChartViewHelpers.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 15.01.26.
//

import SwiftUI
import Charts

// MARK: - Gesture

extension ChartView {

    var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 20)
            .onEnded { value in
                let dx = value.translation.width
                let dy = value.translation.height
                guard abs(dx) > abs(dy) else { return }
                let threshold: CGFloat = 40
                if dx <= -threshold {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        viewModel.shiftPeriod(1)
                    }
                } else if dx >= threshold {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        viewModel.shiftPeriod(-1)
                    }
                }
            }
    }
}

// MARK: - Chart Scale

extension ChartView {

    var yDomain: ClosedRange<Double> {
        let totals = viewModel.aggregated.map(\.total)
        guard let minVal = totals.min(), let maxVal = totals.max() else {
            return 0...1000
        }
        if totals.count == 1 {
            let v = totals[0]
            return max(0, v - 500)...(v + 500)
        }
        let range   = maxVal - minVal
        let padding = range * 0.15
        return max(0, minVal - padding)...(maxVal + padding)
    }
}

// MARK: - Sub-views

extension ChartView {

    @ViewBuilder
    func summaryCard(
        title: String,
        amount: Double,
        isSelected: Bool,
        color: Color,
        currency: Currency
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(amount, format: .currency(code: currency.rawValue))
                .font(.headline)
                .foregroundStyle(isSelected ? color : .primary)
                .contentTransition(.numericText())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(isSelected ? color.opacity(0.12) : Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(isSelected ? color.opacity(0.4) : .clear, lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
