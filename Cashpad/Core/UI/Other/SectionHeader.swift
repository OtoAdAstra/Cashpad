//
//  SectionHeader.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 22.01.26.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(.top, 4)
    }
}
