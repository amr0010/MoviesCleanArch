//
//  MovieDetailDTO.swift
//  Data
//
//  Created by Amr Magdy on 26/04/2026.
//

import Domain

struct MovieDetailDTO: Decodable {
    let id: Int?
    let title: String?
    let posterPath: String?
    let releaseDate: String?
    let genres: [GenreDTO]?
    let overview: String?
    let homepage: String?
    let budget: Int?
    let revenue: Int?
    let spokenLanguages: [SpokenLanguageDTO]?
    let status: String?
    let runtime: Int?

    enum CodingKeys: String, CodingKey {
        case id, title, overview, homepage, budget, revenue, status, runtime, genres
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case spokenLanguages = "spoken_languages"
    }

    func toDomain() -> MovieDetail? {
        guard let id, let title else { return nil }
        return MovieDetail(
            id: id,
            title: title,
            posterPath: posterPath,
            releaseDate: releaseDate ?? "",
            genres: genres?.compactMap { $0.toDomain() } ?? [],
            overview: overview ?? "",
            homepage: homepage,
            budget: budget ?? 0,
            revenue: revenue ?? 0,
            spokenLanguages: spokenLanguages?.compactMap { $0.englishName } ?? [],
            status: status ?? "",
            runtime: runtime
        )
    }
}

struct SpokenLanguageDTO: Decodable {
    let englishName: String?

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
    }
}
