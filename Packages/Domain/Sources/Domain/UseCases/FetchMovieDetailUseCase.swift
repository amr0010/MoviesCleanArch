//
//  FetchMovieDetailUseCase.swift
//  Domain
//
//  Created by Amr Magdy on 26/04/2026.
//

public struct FetchMovieDetailUseCase: Sendable {
    private let repository: any MoviesRepositoryProtocol

    public init(repository: any MoviesRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(id: Int) async throws -> MovieDetail {
        try await repository.fetchMovieDetail(id: id)
    }
}
