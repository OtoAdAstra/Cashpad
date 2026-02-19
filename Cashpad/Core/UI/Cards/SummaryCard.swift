//
//  SummaryCard.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 20.01.26.
//

import SwiftUI

struct summaryCard: View {

    let title: String
    let amount: Double
    let isSelected: Bool
    let color: Color
    let currency: Currency

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("\(String(format: "%.2f", amount)) \(currency.symbol)")
            .font(.title2.bold())
            .foregroundStyle(color)
            .monospacedDigit()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(background)
        .overlay(border)
        .animation(.snappy, value: isSelected)
    }

    private var background: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(isSelected ? Color.gray.opacity(0.15) : Color.gray.opacity(0.07))
    }

    private var border: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .stroke(
                isSelected ? color.opacity(0.6) : .clear,
                lineWidth: 2
            )
    }
}
