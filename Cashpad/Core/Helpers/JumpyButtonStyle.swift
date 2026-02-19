//
//  JumpyButtonStyle.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 11.01.26.
//


import SwiftUI

struct JumpyButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.3 : 1)
            .animation(
                .interpolatingSpring(
                    stiffness: 300,
                    damping: 15
                ),
                value: configuration.isPressed
            )
    }
}
