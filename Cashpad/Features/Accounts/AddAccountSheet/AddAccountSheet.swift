//
//  AddAccountSheet.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 13.01.26.
//


import SwiftUI

struct AddAccountSheet: View {
    
    @State private var name: String = ""
    @State private var selectedColor: AccountColor = .blue
    @State private var selectedIcon: AccountIcon = .creditCard
    @State private var selectedCurrency: Currency = .usd
    @State private var initialBalance: String = ""
    
    @FocusState private var focusedField: Field?
    
    let onSave: (
        String, 
        String,
        String?,
        String?,
        Double
    ) -> Void
    
    let onCancel: () -> Void
    
    private let colorColumns = Array(
        repeating: GridItem(.flexible(), spacing: 12),
        count: 5
    )
    
    private let iconColumns = Array(
        repeating: GridItem(.flexible(), spacing: 12),
        count: 5
    )
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Color Picker
                    sectionContainer {
                        VStack(alignment: .leading, spacing: 12) {
                            sectionTitle("Color")
                            
                            LazyVGrid(columns: colorColumns, spacing: 12) {
                                ForEach(AccountColor.allCases) { color in
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(color.color)
                                            .frame(height: 44)
                                        
                                        if color == selectedColor {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .onTapGesture {
                                        selectedColor = color
                                    }
                                }
                            }
                        }
                    }
                    
                    // MARK: - Emoji Picker
                    sectionContainer {
                        VStack(alignment: .leading, spacing: 12) {
                            sectionTitle("Icon")
                            
                            LazyVGrid(columns: iconColumns, spacing: 12) {
                                ForEach(AccountIcon.allCases) { icon in
                                    ZStack {
                                        Circle()
                                            .fill(
                                                icon == selectedIcon
                                                ? selectedColor.color.opacity(0.2)
                                                : Color.clear
                                            )
                                            .frame(height: 48)

                                        Image(systemName: icon.rawValue)
                                            .font(.system(size: 22, weight: .semibold))
                                            .foregroundColor(selectedColor.color)
                                    }
                                    .frame(height: 48)
                                    .onTapGesture {
                                        selectedIcon = icon
                                    }
                                }
                            }
                        }
                    }
                    
                    // MARK: - Account Name
                    sectionContainer {
                        VStack(alignment: .leading, spacing: 8) {
                            sectionTitle("Account Name")
                            
                            TextField(
                                "e.g. Personal Checking",
                                text: $name
                            )
                            .textFieldStyle(.plain)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                            )
                            .focused($focusedField, equals: .name)
                        }
                    }
                    
                    // MARK: - Initial Balance (optional)
                    sectionContainer {
                        VStack(alignment: .leading, spacing: 8) {
                            sectionTitle("Initial Balance")
                            
                            HStack {
                                Text(selectedCurrency.symbol)
                                    .font(.system(size: 28, weight: .medium))
                                    .foregroundColor(.secondary)
                                
                                TextField("0.00", text: $initialBalance)
                                    .keyboardType(.decimalPad)
                                    .font(.system(size: 32, weight: .regular))
                                    .focused($focusedField, equals: .initialBalance)
                            }
                        }
                    }
                    
                    // MARK: - Currency
                    sectionContainer {
                        VStack(alignment: .leading, spacing: 8) {
                            sectionTitle("Currency")
                            
                            Picker("Currency", selection: $selectedCurrency) {
                                ForEach(Currency.allCases) { currency in
                                    Text(currency.rawValue)
                                        .tag(currency)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                    
                    // MARK: - Save Button
                    Button {
                        let balance = Double(initialBalance.replacingOccurrences(of: ",", with: ".")) ?? 0
                        
                        onSave(
                            name,
                            selectedCurrency.rawValue,
                            selectedIcon.rawValue,
                            selectedColor.rawValue,
                            balance
                        )
                    } label: {
                        Text("Add Account")
                            .font(.system(size: 17, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color("AppleBlue").opacity(name.isEmpty ? 0.4 : 1))
                            )
                            .foregroundColor(.white)
                    }
                    .disabled(name.isEmpty)
                }
                .padding(16)
            }
            .navigationTitle("Add Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
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
