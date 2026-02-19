//
//  TotalAccountsBalanceView.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 09.01.26.
//

import SwiftUI

struct TotalAccountsBalanceView: View {

    let currency: String
    let balance: String
    let trend: SpendingTrend

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack {
                Text("Total Balance")
                    .font(Font.system(size: 14))
                    .foregroundColor(
                        Color(red: 1, green: 1, blue: 1).opacity(0.8)
                    )

                Spacer()

                Image(systemName: trend.symbolName)
                    .foregroundColor(trend.color)
                    .font(.system(size: 18, weight: .semibold))
                    .symbolRenderingMode(.hierarchical)
            }

            Text("\(currency)\(balance)")
                .foregroundColor(.white)
                .font(.system(size: 32))

        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 0)
        .frame(
            maxWidth: .infinity,
            minHeight: 120,
            maxHeight: 120,
            alignment: .topLeading
        )
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(
                        color: Color(red: 0, green: 0.48, blue: 1),
                        location: 0.00
                    ),
                    Gradient.Stop(
                        color: Color(red: 0.35, green: 0.34, blue: 0.84),
                        location: 1.00
                    ),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
        )
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
        .shadow(color: .black.opacity(0.1), radius: 1.5, x: 0, y: 1)
    }

}
