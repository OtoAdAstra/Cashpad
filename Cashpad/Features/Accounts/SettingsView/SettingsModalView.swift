//
//  SettingsModalView.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 11.01.26.
//

import SwiftUI

struct SettingsModalView: View {

    @ObservedObject var viewModel: AccountsViewModel
    
    @Binding var showSettings: Bool
    let animation: Namespace.ID

    @State private var showClearAlert: Bool = false
    @State private var showCurrencyPicker: Bool = false

    var body: some View {
        VStack(spacing: 16) {

            HStack {
                Button {
                    showSettings = false
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.backward")
                        Text("Go back")
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color("AppleBlue"))
                }

                Spacer()

                Text("Settings")
                    .font(.title2.bold())
            }
            .padding(8)

            Divider()

            VStack(spacing: 20) {

                SectionHeader(title: "Appearance")
                themeRow

                SectionHeader(title: "Currency")
                currencyRow

                SectionHeader(title: "Privacy")
                faceIDRow

                SectionHeader(title: "Danger Zone")
                clearAccountsRow
            }
            .padding(.top, 4)

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(.ultraThinMaterial)
                .matchedGeometryEffect(id: "settingsGlass", in: animation)
        )
        .ignoresSafeArea(edges: .bottom)
        .padding(.horizontal, 5)
        .confirmationDialog(
            "Clear all accounts?",
            isPresented: $showClearAlert,
            titleVisibility: .visible
        ) {
            Button("Clear Accounts", role: .destructive) {
                viewModel.clearAccounts()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently delete all account data from this device.")
        }
        .onChange(of: viewModel.selectedTheme) { _, newValue in
            viewModel.updateTheme(newValue)
        }
        .onChange(of: viewModel.selectedCurrency) { _, newValue in
            viewModel.updateCurrency(newValue)
        }
        .onChange(of: viewModel.requireFaceID) { _, newValue in
            viewModel.updateFaceID(newValue)
        }
    }

    // MARK: - Rows

    private var themeRow: some View {
        HStack(spacing: 12) {
            Image(systemName: viewModel.selectedTheme.icon)
                .foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 2) {
                Text("Theme")
                    .font(.headline)
                Text(viewModel.selectedTheme.title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Picker("Theme", selection: $viewModel.selectedTheme) {
                ForEach(AppTheme.allCases) { theme in
                    Text(theme.title).tag(theme)
                }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 260)
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 14).fill(.thinMaterial))
    }

    private var currencyRow: some View {
        HStack(spacing: 12) {
            Image(systemName: "dollarsign.arrow.circlepath")
                .foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 2) {
                Text("Default Currency")
                    .font(.headline)
                Text(viewModel.selectedCurrency)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                showCurrencyPicker = true
            } label: {
                Label("Choose", systemImage: "chevron.up.chevron.down")
                    .labelStyle(.titleAndIcon)
            }
            .buttonStyle(.bordered)
            .sheet(isPresented: $showCurrencyPicker) {
                NavigationView {
                    List {
                        ForEach(Currency.allCases, id: \.rawValue) { currency in
                            Button {
                                viewModel.updateCurrency(currency.rawValue.uppercased())
                                showCurrencyPicker = false
                            } label: {
                                HStack {
                                    Text(currency.rawValue.uppercased())
                                    if viewModel.selectedCurrency == currency.rawValue.uppercased() {
                                        Spacer()
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(.primary)
                                    }
                                }
                            }
                        }
                    }
                    .navigationTitle("Select Currency")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Done") { showCurrencyPicker = false }
                        }
                    }
                }
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 14).fill(.thinMaterial))
    }

    private var faceIDRow: some View {
        HStack(spacing: 12) {
            Image(systemName: "lock.fill")
                .foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 2) {
                Text("Require Passcode")
                    .font(.headline)
                Text("Unlock the app with Passcode")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Toggle("", isOn: $viewModel.requireFaceID)
                .labelsHidden()
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 14).fill(.thinMaterial))
    }

    private var clearAccountsRow: some View {
        Button(role: .destructive) {
            showClearAlert = true
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "trash")
                Text("Clear Accounts")
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
            }
            .font(.headline)
            .padding(14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(RoundedRectangle(cornerRadius: 14).fill(.thinMaterial))
    }
}
