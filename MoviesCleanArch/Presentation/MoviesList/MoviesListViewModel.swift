//
//  MoviesListViewModel.swift
//  MoviesCleanArch
//
//  Created by Amr Magdy on 26/04/2026.
//

import Foundation
import Observation
import Domain

@Observable
@MainActor
final class MoviesListViewModel {
    private(set) var movies: [Movie] = []
    private(set) var genres: [Genre] = []
    private(set) var isLoading = false
    private(set) var isLoadingNextPage = false
    private(set) var errorMessage: String? = nil

    var selectedGenreIds: Set<Int> = []
    var searchText: String = ""

    private var currentPage = 1
    private var canLoadMore = true

    private let fetchMoviesUseCase: FetchTrendingMoviesUseCase
    private let fetchGenresUseCase: FetchGenresUseCase
    private let fetchDetailUseCase: FetchMovieDetailUseCase

    init(
        fetchMoviesUseCase: FetchTrendingMoviesUseCase,
        fetchGenresUseCase: FetchGenresUseCase,
        fetchDetailUseCase: FetchMovieDetailUseCase
    ) {
        self.fetchMoviesUseCase = fetchMoviesUseCase
        self.fetchGenresUseCase = fetchGenresUseCase
        self.fetchDetailUseCase = fetchDetailUseCase
    }

    var filteredMovies: [Movie] {
        movies
            .filter { selectedGenreIds.isEmpty || !Set($0.genreIds).isDisjoint(with: selectedGenreIds) }
            .filter { searchText.isEmpty || $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    func loadInitial() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        currentPage = 1
        canLoadMore = true

        do {
            async let moviesTask = fetchMoviesUseCase.execute(page: 1)
            async let genresTask = fetchGenresUseCase.execute()
            let (page, fetchedGenres) = try await (moviesTask, genresTask)
            movies = page.movies
            genres = fetchedGenres
            canLoadMore = page.currentPage < page.totalPages
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func loadNextPageIfNeeded(currentMovieId: Int) async {
        guard currentMovieId == movies.last?.id,
              !isLoadingNextPage,
              canLoadMore else { return }

        isLoadingNextPage = true
        let nextPage = currentPage + 1

        do {
            let page = try await fetchMoviesUseCase.execute(page: nextPage)
            movies.append(contentsOf: page.movies)
            currentPage = nextPage
            canLoadMore = page.currentPage < page.totalPages
        } catch {
            // silently fail — existing list stays intact
        }

        isLoadingNextPage = false
    }

    func toggleGenre(_ genre: Genre) {
        if selectedGenreIds.contains(genre.id) {
            selectedGenreIds.remove(genre.id)
        } else {
            selectedGenreIds.insert(genre.id)
        }
    }

    func retry() async {
        await loadInitial()
    }

    func makeDetailViewModel(movieId: Int) -> MovieDetailViewModel {
        MovieDetailViewModel(movieId: movieId, fetchDetailUseCase: fetchDetailUseCase)
    }
}
