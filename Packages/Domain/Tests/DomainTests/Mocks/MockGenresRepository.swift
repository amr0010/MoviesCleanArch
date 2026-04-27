//
//  MockGenresRepository.swift
//  DomainTests
//
//  Created by Amr Magdy on 26/04/2026.
//

import Domain

final class MockGenresRepository: GenresRepositoryProtocol, @unchecked Sendable {
    var stubbedGenres: [Genre] = []
    var shouldThrow = false

    func fetchGenres() async throws -> [Genre] {
        if shouldThrow { throw TestError.stub }
        return stubbedGenres
    }
}
