//
//  CachedAsyncImage.swift
//  MoviesCleanArch
//
//  Created by Amr Magdy on 26/04/2026.
//

import SwiftUI

struct CachedAsyncImage: View {
    let url: URL?

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ZStack {
                    Color(.systemGray6)
                    ProgressView()
                }
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                ZStack {
                    Color(.systemGray6)
                    Image(systemName: "film")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                }
            @unknown default:
                EmptyView()
            }
        }
    }
}
