//
//  GenreChipView.swift
//  MoviesCleanArch
//
//  Created by Amr Magdy on 26/04/2026.
//

import SwiftUI
import Domain

struct GenreChipView: View {
    let genre: Genre
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(genre.name)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isSelected ? Color.accentColor : Color.clear)
                .foregroundStyle(isSelected ? Color.white : Color.primary)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(
                            isSelected ? Color.accentColor : Color.secondary.opacity(0.4),
                            lineWidth: 1
                        )
                )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}
