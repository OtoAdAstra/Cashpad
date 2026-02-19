//
//  AccountsCardsView.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 09.01.26.
//

import SwiftUI

struct AccountsCardsView: View {

    let accountName: String
    let currency: String
    let balance: String
    let trend: SpendingTrend
    let color: AccountColor
    let icon: AccountIcon

    let onDelete: () -> Void

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            HStack {

                HStack {
                    Image(systemName: icon.rawValue)
                        .foregroundStyle(color.color)

                    Text(accountName)
                        .font(Font.system(size: 16))
                        .foregroundColor(
                            Color(red: 0.56, green: 0.56, blue: 0.58)
                        )
                }

                Spacer()

                HStack {
                    Image(systemName: trend.symbolName)
                        .foregroundColor(trend.color)
                        .font(.system(size: 14, weight: .semibold))
                        .symbolRenderingMode(.hierarchical)

                    Menu {
                        Button(role: .destructive) {
                            onDelete()
                        } label: {
                            Label("Delete Account", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.secondary)
                            .frame(width: 32, height: 32)
                    }
                }
            }

            HStack {
                Text("\(currency)\(balance)")
                    .foregroundColor(.primary)
                    .font(.system(size: 30))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.primary)
                    .font(.system(size: 18, weight: .regular))
            }
            .padding(.trailing, 16)
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 0)
        .frame(
            maxWidth: .infinity,
            minHeight: 122,
            maxHeight: 122,
            alignment: .topLeading
        )
        .background(Color("Background"))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
        .shadow(color: .black.opacity(0.1), radius: 1.5, x: 0, y: 1)
    }
}
