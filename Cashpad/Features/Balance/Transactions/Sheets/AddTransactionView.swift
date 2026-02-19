//
//  AddTransactionView.swift
//  testUIKit
//
//  Created by Oto Sharvashidze on 19.01.26.
//

import SwiftUI

struct AddTransactionView: View {

    // MARK: - State
    @State private var type: TransactionType = .expense
    @State private var amount: String = ""
    @State private var date: Date = .now
    @State private var note: String = ""

    @FocusState private var focusedField: Field?

    // MARK: - Actions
    let onSave: (
        Double,
        Date,
        String?,
        TransactionType
    ) -> Void

    let onCancel: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    // MARK: - Type Picker
                    sectionContainer {
                        VStack(alignment: .leading, spacing: 8) {
                            sectionTitle("Type")

                            Picker("Type", selection: $type) {
                                ForEach(TransactionType.allCases) { type in
                                    Text(type.rawValue)
                                        .tag(type)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }

                    // MARK: - Amount
                    sectionContainer {
                        VStack(alignment: .leading, spacing: 8) {
                            sectionTitle("Amount")

                            HStack(alignment: .firstTextBaseline, spacing: 8) {
                                if type == .expense {
                                    Text("–")
                                        .font(.system(size: 32, weight: .medium))
                                        .foregroundColor(.secondary)
                                }

                                TextField("0.00", text: $amount)
                                    .keyboardType(.decimalPad)
                                    .font(.system(size: 32, weight: .regular))
                                    .focused($focusedField, equals: .amount)
                            }
                        }
                    }

                    // MARK: - Date
                    sectionContainer {
                        VStack(alignment: .leading, spacing: 8) {
                            sectionTitle("Date")

                            DatePicker(
                                "Date",
                                selection: $date,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.compact)
                        }
                    }

                    // MARK: - Note
                    sectionContainer {
                        VStack(alignment: .leading, spacing: 8) {
                            sectionTitle("Note")

                            TextField(
                                "Optional note",
                                text: $note
                            )
                            .textFieldStyle(.plain)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                            )
                            .focused($focusedField, equals: .note)
                        }
                    }

                    // MARK: - Save Button
                    Button {
                        let numericAmount =
                            Double(amount.replacingOccurrences(of: ",", with: ".")) ?? 0

                        let signedAmount =
                            type == .expense ? -abs(numericAmount) : abs(numericAmount)

                        onSave(
                            signedAmount,
                            date,
                            note.isEmpty ? nil : note,
                            type
                        )
                        
                        onCancel()
                    } label: {
                        Text("Add Transaction")
                            .font(.system(size: 17, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        Color("AppleBlue")
                                            .opacity(amount.isEmpty ? 0.4 : 1)
                                    )
                            )
                            .foregroundColor(.white)
                    }
                    .disabled(amount.isEmpty)
                }
                .padding(16)
            }
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        onCancel()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }

                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
        }
    }
}
