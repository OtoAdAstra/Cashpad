//
//  AccountsCardsListView.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 11.01.26.
//


import SwiftUI

struct AccountsCardsListView: View {

    @ObservedObject var viewModel: AccountsViewModel
    let onAccountSelected: (AccountModel) -> Void

    var body: some View {

        ScrollView {
            VStack(spacing: 16) {

                let totalCurrency = Currency(
                    rawValue: viewModel.selectedCurrency
                ) ?? .usd

                TotalAccountsBalanceView(
                    currency: totalCurrency.symbol,
                    balance: viewModel.totalBalanceString,
                    trend: viewModel.totalSpendingTrend()
                )

                VStack(spacing: 12) {
                    ForEach(viewModel.accounts) { account in

                        let currency = Currency(
                            rawValue: account.currency
                        ) ?? .usd
                        let color = AccountColor(rawValue: account.color ?? "") ?? .blue
                        let icon = AccountIcon(rawValue: account.emoji ?? "") ?? .creditCard
                        
                        AccountsCardsView(
                            accountName: account.name,
                            currency: currency.symbol,
                            balance: viewModel.formattedBalance(for: account),
                            trend: viewModel.spendingTrend(for: account),
                            color: color,
                            icon: icon,
                            onDelete: {
                                if let index = viewModel.accounts.firstIndex(where: { $0.id == account.id }) {
                                    viewModel.deleteAccount(at: index)
                                }
                            }
                        )
                        .onTapGesture {
                            Haptic.tap()
                            onAccountSelected(account)
                        }
                    }
                }
            }
            .padding(16)
        }
    }
}
