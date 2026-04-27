//
//  DefaultGenresRepository.swift
//  Data
//
//  Created by Amr Magdy on 26/04/2026.
//

import Domain

public final class DefaultGenresRepository: @unchecked Sendable, GenresRepositoryProtocol {
    private let apiClient: APIClient
    private let store: CoreDataMoviesStore

    public init(apiClient: APIClient, store: CoreDataMoviesStore) {
        self.apiClient = apiClient
        self.store = store
    }

    public func fetchGenres() async throws -> [Genre] {
        do {
            let response: GenreListResponseDTO = try await apiClient.request(.genres())
            let genres = response.genres?.compactMap { $0.toDomain() } ?? []
            try? store.saveGenres(genres)
            return genres
        } catch {
            let cached = try store.loadGenres()
            if cached.isEmpty { throw error }
            return cached
        }
    }
}
