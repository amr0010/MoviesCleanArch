//
//  GenreDTOTests.swift
//  DataTests
//
//  Created by Amr Magdy on 26/04/2026.
//

import XCTest
@testable import Data

final class GenreDTOTests: XCTestCase {

    func test_decodeGenreList_parsesCorrectly() throws {
        let data = try fixture("genre_list_response")
        let response = try JSONDecoder().decode(GenreListResponseDTO.self, from: data)

        XCTAssertEqual(response.genres?.count, 3)
    }

    func test_genreDTO_mapsToCorrectDomainEntity() throws {
        let data = try fixture("genre_list_response")
        let response = try JSONDecoder().decode(GenreListResponseDTO.self, from: data)
        let genre = response.genres?.first?.toDomain()

        XCTAssertEqual(genre?.id, 18)
        XCTAssertEqual(genre?.name, "Drama")
    }
}

private func fixture(_ name: String) throws -> Data {
    guard let url = Bundle.module.url(forResource: name, withExtension: "json", subdirectory: "Fixtures") else {
        throw XCTestError(.failureWhileWaiting, userInfo: [NSLocalizedDescriptionKey: "Fixture '\(name).json' not found"])
    }
    return try Data(contentsOf: url)
}
