//
//  MovieCardView.swift
//  MoviesCleanArch
//
//  Created by Amr Magdy on 26/04/2026.
//

import SwiftUI
import Domain

struct MovieCardView: View {
    let movie: Movie

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            CachedAsyncImage(url: movie.posterURL)
                .frame(height: 260)
                .clipped()

            LinearGradient(
                colors: [.black.opacity(0.75), .clear],
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 100)

            VStack(alignment: .leading, spacing: 2) {
                Text(movie.title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .lineLimit(2)

                if !movie.releaseYear.isEmpty {
                    Text(movie.releaseYear)
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.75))
                }
            }
            .padding(10)
        }
        .cornerRadius(12)
        .clipped()
    }
}
