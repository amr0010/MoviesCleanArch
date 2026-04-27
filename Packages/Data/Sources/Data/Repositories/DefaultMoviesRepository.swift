//
//  DefaultMoviesRepository.swift
//  Data
//
//  Created by Amr Magdy on 26/04/2026.
//

import Domain

public final class DefaultMoviesRepository: @unchecked Sendable, MoviesRepositoryProtocol {
    private let apiClient: APIClient
    private let store: CoreDataMoviesStore

    public init(apiClient: APIClient, store: CoreDataMoviesStore) {
        self.apiClient = apiClient
        self.store = store
    }

    public func fetchTrendingMovies(page: Int) async throws -> MoviesPage {
        do {
            let response: PagedResponseDTO<MovieDTO> = try await apiClient.request(.discoverMovies(page: page))
            let movies = response.results?.compactMap { $0.toDomain() } ?? []
            try? store.saveMovies(movies, page: page)
            return MoviesPage(movies: movies, currentPage: page, totalPages: response.totalPages ?? 1)
        } catch {
            let cached = try store.loadMovies(page: page)
            if cached.isEmpty { throw error }
            return MoviesPage(movies: cached, currentPage: page, totalPages: 1)
        }
    }

    public func fetchMovieDetail(id: Int) async throws -> MovieDetail {
        let dto: MovieDetailDTO = try await apiClient.request(.movieDetail(id: id))
        guard let detail = dto.toDomain() else { throw APIError.noData }
        return detail
    }
}
