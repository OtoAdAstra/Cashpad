//
//  FilterDateRow.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 25.01.26.
//

import SwiftUI

struct FilterDateRow: View {

    let title: String
    @Binding var date: Date?

    @State private var showPicker = false

    var body: some View {
        Button {
            showPicker.toggle()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(dateLabel)
                        .font(.body)
                        .foregroundStyle(date == nil ? .secondary : .primary)
                }

                Spacer()

                Image(systemName: "calendar")
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(.thinMaterial)
            )
        }
        .buttonStyle(.plain)
        .popover(isPresented: $showPicker) {
            DatePicker(
                title,
                selection: Binding(
                    get: { date ?? Date() },
                    set: { newValue in
                        date = newValue
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            showPicker = false
                        }
                    }                ),
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .padding()
        }
    }

    private var dateLabel: String {
        guard let date else { return "Any date" }
        return date.formatted(date: .abbreviated, time: .omitted)
    }
}
