//
//  GenreDTO.swift
//  Data
//
//  Created by Amr Magdy on 26/04/2026.
//

import Domain

struct GenreDTO: Decodable {
    let id: Int?
    let name: String?

    func toDomain() -> Genre? {
        guard let id, let name else { return nil }
        return Genre(id: id, name: name)
    }
}

struct GenreListResponseDTO: Decodable {
    let genres: [GenreDTO]?
}
