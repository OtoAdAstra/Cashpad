//
//  TransactionFilterView.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 25.01.26.
//


import SwiftUI

struct TransactionFilterView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var startDate: Date? = nil
    @State private var endDate: Date? = nil

    @State private var minAmount: String = ""
    @State private var maxAmount: String = ""

    let onApply: (TransactionFilter) -> Void
    let onReset: (() -> Void)?
    var isFilterApplied: Bool = false

    var body: some View {
        VStack(spacing: 18) {

            // MARK: - Title
            Text("Filter Transactions")
                .font(.headline)
                .padding(.bottom, 4)

            // MARK: - Date Range
            VStack(spacing: 12) {
                FilterDateRow(
                    title: "Start Date",
                    date: $startDate
                )

                FilterDateRow(
                    title: "End Date",
                    date: $endDate
                )
            }

            // MARK: - Amount Range
            VStack(spacing: 12) {
                FilterAmountField(
                    title: "Minimum Amount",
                    placeholder: "No minimum",
                    text: $minAmount
                )

                FilterAmountField(
                    title: "Maximum Amount",
                    placeholder: "No maximum",
                    text: $maxAmount
                )
            }

            Divider()
                .padding(.vertical, 4)

            // MARK: - Apply / Reset
            if isFilterApplied {
                Button(role: .destructive) {
                    onReset?()
                    dismiss()
                } label: {
                    Text("Reset Filters")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            } else {
                Button {
                    onApply(
                        TransactionFilter(
                            startDate: startDate,
                            endDate: endDate,
                            minAmount: Double(minAmount),
                            maxAmount: Double(maxAmount)
                        )
                    )
                    dismiss()
                } label: {
                    Text("Apply Filters")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }

        }
        .padding(20)
        .frame(width: 300)
        .background(.ultraThinMaterial)
    }
}

