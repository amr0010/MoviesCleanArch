//
//  InfoRow.swift
//  MoviesCleanArch
//
//  Created by Amr Magdy on 26/04/2026.
//

import SwiftUI

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(width: 90, alignment: .leading)
                .foregroundStyle(.primary)

            Text(value)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()
        }
    }
}
