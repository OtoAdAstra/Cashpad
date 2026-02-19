//
//  IconCircleButton.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 09.01.26.
//

import SwiftUI

struct IconCircleButton: View {

    let systemName: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                Image(systemName: systemName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.primary)
            }
            .frame(width: 38, height: 38)
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.circle)
    }
}
