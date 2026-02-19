//
//  addButtonView.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 11.01.26.
//


import SwiftUI

struct AddButtonView: View {
    
    var onAction: () -> Void
    
    var body: some View {
        Button {
            onAction()
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 26, weight: .regular))
                .foregroundStyle(.white)
                .padding(16)
        }
        .buttonStyle(.glassProminent)
        .buttonBorderShape(.circle)
        .tint(.blue)
        .glassEffect(.regular.interactive(), in: .circle)
        .padding(.trailing, 32)
        .padding(.bottom, 32)
    }
}
