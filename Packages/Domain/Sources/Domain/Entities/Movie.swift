//
//  Movie.swift
//  Domain
//
//  Created by Amr Magdy on 26/04/2026.
//

public struct Movie: Identifiable, Hashable, Sendable {
    public let id: Int
    public let title: String
    public let posterPath: String?
    public let releaseDate: String
    public let genreIds: [Int]

    public init(id: Int, title: String, posterPath: String?, releaseDate: String, genreIds: [Int]) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.genreIds = genreIds
    }
}
