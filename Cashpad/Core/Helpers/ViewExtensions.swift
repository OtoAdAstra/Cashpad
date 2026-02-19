//
//  GlassButtonHelper.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 10.01.26.
//

import SwiftUI

extension View {

    @ViewBuilder
    func glassButtonStyleIfAvailable() -> some View {
        if #available(iOS 26.0, *) {
            self.buttonStyle(.glass)
        } else {
            self.buttonStyle(JumpyButtonStyle())
        }
    }

    @ViewBuilder
    func glassButtonBackgroundIfAvailable() -> some View {
        if #available(iOS 26.0, *) {
            self
        } else {
            self.background(
                Circle()
                    .fill(Color(.systemGray6))
            )
        }
    }
    
    @ViewBuilder
    func applyIf<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func sectionContainer<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("SecondaryBackground"))
            )
    }
    
    @ViewBuilder
    func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(.primary)
    }
    
}
