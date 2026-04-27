//
//  MovieDTO.swift
//  Data
//
//  Created by Amr Magdy on 26/04/2026.
//

import Domain

struct MovieDTO: Decodable {
    let id: Int?
    let title: String?
    let posterPath: String?
    let releaseDate: String?
    let genreIds: [Int]?

    enum CodingKeys: String, CodingKey {
        case id, title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
    }

    func toDomain() -> Movie? {
        guard let id, let title else { return nil }
        return Movie(
            id: id,
            title: title,
            posterPath: posterPath,
            releaseDate: releaseDate ?? "",
            genreIds: genreIds ?? []
        )
    }
}

struct PagedResponseDTO<T: Decodable>: Decodable {
    let results: [T]?
    let totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case results
        case totalPages = "total_pages"
    }
}
