//
//  MockMoviesRepository.swift
//  DomainTests
//
//  Created by Amr Magdy on 26/04/2026.
//

import Domain

enum TestError: Error { case stub }

final class MockMoviesRepository: MoviesRepositoryProtocol, @unchecked Sendable {
    var stubbedPage = MoviesPage(movies: [], currentPage: 1, totalPages: 1)
    var stubbedDetail = MovieDetail(
        id: 1, title: "Mock", posterPath: nil, releaseDate: "2024-01-01",
        genres: [], overview: "", homepage: nil, budget: 0, revenue: 0,
        spokenLanguages: [], status: "", runtime: nil
    )
    var shouldThrow = false

    func fetchTrendingMovies(page: Int) async throws -> MoviesPage {
        if shouldThrow { throw TestError.stub }
        return stubbedPage
    }

    func fetchMovieDetail(id: Int) async throws -> MovieDetail {
        if shouldThrow { throw TestError.stub }
        return stubbedDetail
    }
}
