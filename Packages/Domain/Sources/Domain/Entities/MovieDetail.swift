//
//  MovieDetail.swift
//  Domain
//
//  Created by Amr Magdy on 26/04/2026.
//

public struct MovieDetail: Identifiable, Sendable {
    public let id: Int
    public let title: String
    public let posterPath: String?
    public let releaseDate: String
    public let genres: [Genre]
    public let overview: String
    public let homepage: String?
    public let budget: Int
    public let revenue: Int
    public let spokenLanguages: [String]
    public let status: String
    public let runtime: Int?

    public init(
        id: Int,
        title: String,
        posterPath: String?,
        releaseDate: String,
        genres: [Genre],
        overview: String,
        homepage: String?,
        budget: Int,
        revenue: Int,
        spokenLanguages: [String],
        status: String,
        runtime: Int?
    ) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.genres = genres
        self.overview = overview
        self.homepage = homepage
        self.budget = budget
        self.revenue = revenue
        self.spokenLanguages = spokenLanguages
        self.status = status
        self.runtime = runtime
    }
}
