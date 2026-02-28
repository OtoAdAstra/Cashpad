//
//  TransactionRow.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 22.01.26.
//

import SwiftUI

// MARK: - Swipe-to-Delete Modifier

private struct SwipeToDeleteModifier: ViewModifier {

    var onDelete: () -> Void

    @GestureState private var dragOffset: CGFloat = 0

    @State private var committedOffset: CGFloat = 0

    private let revealWidth: CGFloat = 72

    private var totalOffset: CGFloat {
        (committedOffset + dragOffset).clamped(to: -revealWidth ... 0)
    }

    private var revealProgress: CGFloat {
        max(abs(totalOffset) / revealWidth, .leastNormalMagnitude)
    }

    private var isOpen: Bool { committedOffset < 0 }

    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            deleteButton
            content
                .offset(x: totalOffset)
                .gesture(swipeGesture)
        }
        .clipped()
    }

    // MARK: Delete button

    private var deleteButton: some View {
        Button(role: .destructive, action: confirmDelete) {
            Label("Delete", systemImage: "trash")
                .labelStyle(.iconOnly)
                .font(.body.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: revealWidth)
                .frame(maxHeight: .infinity)
                .background(.red, in: RoundedRectangle(cornerRadius: 14))
        }
        .opacity(revealProgress)
        .scaleEffect(x: revealProgress, anchor: .trailing)
    }

    // MARK: Gesture

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 12, coordinateSpace: .local)
            .updating($dragOffset) { value, state, _ in
                let translation = value.translation.width
                if isOpen {
                    state = min(revealWidth, translation)
                } else {
                    state = min(0, translation)
                }
            }
            .onEnded { value in
                let velocity   = value.velocity.width
                let translation = value.translation.width

                withAnimation(.interpolatingSpring(stiffness: 300, damping: 30)) {
                    if isOpen {
                        if translation > revealWidth / 2 || velocity > 300 {
                            committedOffset = 0
                        } else {
                            committedOffset = -revealWidth
                        }
                    } else {
                        if translation < -(revealWidth / 2) || velocity < -300 {
                            committedOffset = -revealWidth
                        } else {
                            committedOffset = 0
                        }
                    }
                }
            }
    }

    // MARK: Confirm delete

    private func confirmDelete() {
        withAnimation(.interpolatingSpring(stiffness: 300, damping: 30)) {
            committedOffset = 0
        }
        onDelete()
    }
}

private extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

// MARK: - View Extension

extension View {
    func swipeToDelete(perform action: @escaping () -> Void) -> some View {
        modifier(SwipeToDeleteModifier(onDelete: action))
    }
}

// MARK: - TransactionRow

struct TransactionRow: View {

    let transaction: Transaction
    var onDelete: (() -> Void)? = nil

    var body: some View {
        rowContent
            .swipeToDelete {
                onDelete?()
            }
    }

    private var rowContent: some View {
        HStack(spacing: 12) {
            iconView
            labelView
            Spacer()
            amountView
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.thinMaterial)
        )
    }

    private var iconView: some View {
        let isIncome = TransactionType(storedValue: transaction.type) == .income
        return Circle()
            .fill(isIncome ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
            .frame(width: 36, height: 36)
            .overlay {
                Image(systemName: isIncome ? "arrow.down.circle" : "arrow.up.circle")
                    .foregroundStyle(isIncome ? .green : .red)
            }
    }

    private var labelView: some View {
        let isIncome = TransactionType(storedValue: transaction.type) == .income
        return VStack(alignment: .leading, spacing: 4) {
            Text(transaction.note?.nilIfEmpty ?? (isIncome ? "Income" : "Expense"))
                .font(.body)
                .lineLimit(1)
            if let date = transaction.date {
                Text(date.formatted(date: .omitted, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var amountView: some View {
        Text(transaction.amount, format: .number.precision(.fractionLength(2)))
            .font(.headline)
            .monospacedDigit()
    }
}

// MARK: - Helpers

private extension String {
    var nilIfEmpty: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
