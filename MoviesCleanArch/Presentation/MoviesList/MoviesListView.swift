//
//  MoviesListView.swift
//  MoviesCleanArch
//
//  Created by Amr Magdy on 26/04/2026.
//

import SwiftUI
import Domain

struct MoviesListView: View {
    @Bindable var viewModel: MoviesListViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage, viewModel.movies.isEmpty {
                    ErrorStateView(message: error) { await viewModel.retry() }
                } else {
                    content
                }
            }
            .navigationTitle("Trending Movies")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color(.systemBackground), for: .navigationBar)
            .navigationDestination(for: Int.self) { movieId in
                MovieDetailView(viewModel: viewModel.makeDetailViewModel(movieId: movieId))
            }
        }
        .task { await viewModel.loadInitial() }
    }

    private var content: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                Section {
                    movieGrid
                } header: {
                    stickyHeader
                }
            }
        }
    }

    private var stickyHeader: some View {
        VStack(spacing: 0) {
            searchBar
            if !viewModel.genres.isEmpty {
                genreChips
            }
        }
        .background(.bar)
    }

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField("Search movies", text: $viewModel.searchText)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)

            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    private var genreChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.genres) { genre in
                    GenreChipView(
                        genre: genre,
                        isSelected: viewModel.selectedGenreIds.contains(genre.id)
                    ) {
                        viewModel.toggleGenre(genre)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
    }

    private var movieGrid: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(viewModel.filteredMovies) { movie in
                NavigationLink(value: movie.id) {
                    MovieCardView(movie: movie)
                }
                .buttonStyle(.plain)
                .onAppear {
                    Task { await viewModel.loadNextPageIfNeeded(currentMovieId: movie.id) }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 24)
        .overlay(alignment: .bottom) {
            if viewModel.isLoadingNextPage {
                ProgressView()
                    .padding(.bottom, 8)
            }
        }
    }
}
