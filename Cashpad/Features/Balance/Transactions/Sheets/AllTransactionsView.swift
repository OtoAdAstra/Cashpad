//
//  BottomSheetView.swift
//  MapsIOS26BottomSheet
//
//  Created by Balaji Venkatesh on 27/06/25.
//

import SwiftUI

struct AllTransactionsView: View {
    
    @ObservedObject var viewModel: BalanceViewModel
    
    @Binding var sheetDetent: PresentationDetent
    
    @State private var showAddTransactionView: Bool = false
    @State private var showFilterPopover = false
    @FocusState var isFocused: Bool
    
    private var isSheetExpanded: Bool {
        sheetDetent == .large
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(viewModel.groupedTransactions.keys.sorted(by: >), id: \.self) { day in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.headerString(for: day))
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 18)

                        VStack(spacing: 8) {
                            ForEach(viewModel.groupedTransactions[day] ?? []) { tx in
                                TransactionRow(transaction: tx, onDelete: {
                                    viewModel.deleteTransaction(tx)
                                })
                                .padding(.horizontal, 18)
                            }
                        }
                    }
                }
            }
            .padding(.top, 8)
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            HStack(spacing: 10) {
                TextField("Search...", text: $viewModel.searchText)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background {
                            Capsule()
                                .fill(.thinMaterial)
                                .opacity(0.8)
                                .overlay(
                                    Capsule()
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    .white.opacity(0.45),
                                                    .white.opacity(0.1),
                                                    .clear
                                                ],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            ),
                                            lineWidth: 1
                                        )
                                )
                    }
                    .focused($isFocused)
                
                Button {
                    if isSheetExpanded {
                        showFilterPopover.toggle()
                    } else {
                        showAddTransactionView = true
                    }
                } label: {
                    ZStack {
                        if isSheetExpanded || isFocused {
                            Image(systemName: "line.3.horizontal.decrease")
                                .frame(width: 48, height: 48)
                                .glassEffect(in: .circle)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                                .transition(.blurReplace)
                        } else {
                            Image(systemName: "plus")
                                .font(.title2.bold())
                                .frame(width: 48, height: 48)
                                .foregroundStyle(.white)
                                .background(.blue, in: .circle)
                                .transition(.blurReplace)
                        }
                    }
                }
                .popover(isPresented: $showFilterPopover, arrowEdge: .top) {
                    TransactionFilterView(
                        onApply: { filter in
                            viewModel.apply(filter: filter)
                        },
                        onReset: {
                            viewModel.resetFilters()
                        },
                        isFilterApplied: viewModel.isFilterApplied
                    )
                    .presentationCompactAdaptation(.popover)
                }
            }
            .padding(.horizontal, 18)
            .frame(height: 80)
            .padding(.top, 5)
        }
        .animation(.interpolatingSpring(duration: 0.3, bounce: 0, initialVelocity: 0), value: isFocused)
        .onChange(of: isFocused) { _, focused in
            if focused {
                sheetDetent = .large
            }
        }
        .sheet(isPresented: $showAddTransactionView) {
            AddTransactionView(
                onSave: { amount, date, note, type in
                    viewModel.addTransaction(
                        amount: amount,
                        date: date,
                        note: note,
                        type: type
                    )
                },
                onCancel: {
                    showAddTransactionView = false
                }
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
            .background(.thinMaterial.opacity(0.01))
        }
    }
}

