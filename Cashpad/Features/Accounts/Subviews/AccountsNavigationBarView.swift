//
//  AccountsNavigationBarView.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 09.01.26.
//

import SwiftUI

struct AccountsNavigationBarView: View {

    @Binding var showSettings: Bool
    let animation: Namespace.ID

    var body: some View {
        HStack(alignment: .top) {

            Text("Accounts")
                .font(Font.system(size: 36))

            Spacer()

            HStack(spacing: 16) {
                
                IconCircleButton(
                    systemName: "gearshape",
                    action: {
                        guard !showSettings else { return }
                        showSettings = true
                    }
                )
                .applyIf(!showSettings) {
                    $0.matchedGeometryEffect(id: "settingsGlass", in: animation)
                }
            }

        }
        .padding(24)
        .background(Color("Background"))
    }
}
