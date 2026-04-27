//
//  FetchGenresUseCase.swift
//  Domain
//
//  Created by Amr Magdy on 26/04/2026.
//

public struct FetchGenresUseCase: Sendable {
    private let repository: any GenresRepositoryProtocol

    public init(repository: any GenresRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async throws -> [Genre] {
        try await repository.fetchGenres()
    }
}
