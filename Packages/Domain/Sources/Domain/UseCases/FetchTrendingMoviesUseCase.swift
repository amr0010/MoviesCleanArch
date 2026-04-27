//
//  FetchTrendingMoviesUseCase.swift
//  Domain
//
//  Created by Amr Magdy on 26/04/2026.
//

public struct FetchTrendingMoviesUseCase: Sendable {
    private let repository: any MoviesRepositoryProtocol

    public init(repository: any MoviesRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(page: Int) async throws -> MoviesPage {
        try await repository.fetchTrendingMovies(page: page)
    }
}
