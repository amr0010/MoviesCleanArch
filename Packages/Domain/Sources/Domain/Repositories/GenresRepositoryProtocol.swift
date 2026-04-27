//
//  GenresRepositoryProtocol.swift
//  Domain
//
//  Created by Amr Magdy on 26/04/2026.
//

public protocol GenresRepositoryProtocol: Sendable {
    func fetchGenres() async throws -> [Genre]
}
