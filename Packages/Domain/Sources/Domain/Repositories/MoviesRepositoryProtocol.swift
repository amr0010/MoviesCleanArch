//
//  MoviesRepositoryProtocol.swift
//  Domain
//
//  Created by Amr Magdy on 26/04/2026.
//

public protocol MoviesRepositoryProtocol: Sendable {
    func fetchTrendingMovies(page: Int) async throws -> MoviesPage
    func fetchMovieDetail(id: Int) async throws -> MovieDetail
}
