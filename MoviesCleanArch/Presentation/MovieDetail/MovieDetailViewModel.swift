//
//  MovieDetailViewModel.swift
//  MoviesCleanArch
//
//  Created by Amr Magdy on 26/04/2026.
//

import Foundation
import Observation
import Domain

@Observable
@MainActor
final class MovieDetailViewModel {
    private(set) var detail: MovieDetail? = nil
    private(set) var isLoading = false
    private(set) var errorMessage: String? = nil

    private let movieId: Int
    private let fetchDetailUseCase: FetchMovieDetailUseCase

    init(movieId: Int, fetchDetailUseCase: FetchMovieDetailUseCase) {
        self.movieId = movieId
        self.fetchDetailUseCase = fetchDetailUseCase
    }

    func load() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        do {
            detail = try await fetchDetailUseCase.execute(id: movieId)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func retry() async {
        await load()
    }
}
