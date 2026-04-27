//
//  MovieDTOTests.swift
//  DataTests
//
//  Created by Amr Magdy on 26/04/2026.
//

import XCTest
@testable import Data
import Domain

final class MovieDTOTests: XCTestCase {

    func test_decodeMovieList_parsesResultsCorrectly() throws {
        let data = try fixture("movie_list_response")
        let response = try JSONDecoder().decode(PagedResponseDTO<MovieDTO>.self, from: data)

        XCTAssertEqual(response.results?.count, 2)
        XCTAssertEqual(response.totalPages, 42)
    }

    func test_movieDTO_mapsToCorrectDomainEntity() throws {
        let data = try fixture("movie_list_response")
        let response = try JSONDecoder().decode(PagedResponseDTO<MovieDTO>.self, from: data)
        let movie = response.results?.first?.toDomain()

        XCTAssertEqual(movie?.id, 550)
        XCTAssertEqual(movie?.title, "Fight Club")
        XCTAssertEqual(movie?.releaseDate, "1999-10-15")
        XCTAssertEqual(movie?.genreIds, [18, 53])
    }

    func test_movieDetailDTO_mapsToCorrectDomainEntity() throws {
        let data = try fixture("movie_detail_response")
        let dto = try JSONDecoder().decode(MovieDetailDTO.self, from: data)
        let detail = dto.toDomain()

        XCTAssertEqual(detail?.id, 550)
        XCTAssertEqual(detail?.title, "Fight Club")
        XCTAssertEqual(detail?.runtime, 139)
        XCTAssertEqual(detail?.budget, 63_000_000)
        XCTAssertEqual(detail?.genres.count, 2)
        XCTAssertEqual(detail?.spokenLanguages, ["English"])
    }
}

private func fixture(_ name: String) throws -> Data {
    guard let url = Bundle.module.url(forResource: name, withExtension: "json", subdirectory: "Fixtures") else {
        throw XCTestError(.failureWhileWaiting, userInfo: [NSLocalizedDescriptionKey: "Fixture '\(name).json' not found"])
    }
    return try Data(contentsOf: url)
}
