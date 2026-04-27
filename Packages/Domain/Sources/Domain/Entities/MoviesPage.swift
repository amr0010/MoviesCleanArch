//
//  MoviesPage.swift
//  Domain
//
//  Created by Amr Magdy on 26/04/2026.
//

public struct MoviesPage: Sendable {
    public let movies: [Movie]
    public let currentPage: Int
    public let totalPages: Int

    public init(movies: [Movie], currentPage: Int, totalPages: Int) {
        self.movies = movies
        self.currentPage = currentPage
        self.totalPages = totalPages
    }
}
