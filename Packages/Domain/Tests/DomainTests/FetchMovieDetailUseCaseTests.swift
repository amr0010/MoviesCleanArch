//
//  FetchMovieDetailUseCaseTests.swift
//  DomainTests
//
//  Created by Amr Magdy on 26/04/2026.
//

import XCTest
import Domain

final class FetchMovieDetailUseCaseTests: XCTestCase {
    private var sut: FetchMovieDetailUseCase!
    private var repository: MockMoviesRepository!

    override func setUp() {
        super.setUp()
        repository = MockMoviesRepository()
        sut = FetchMovieDetailUseCase(repository: repository)
    }

    func test_execute_returnsDetailFromRepository() async throws {
        let detail = MovieDetail(
            id: 550, title: "Fight Club", posterPath: "/poster.jpg",
            releaseDate: "1999-10-15", genres: [Genre(id: 18, name: "Drama")],
            overview: "An overview.", homepage: "https://example.com",
            budget: 63_000_000, revenue: 100_000_000,
            spokenLanguages: ["English"], status: "Released", runtime: 139
        )
        repository.stubbedDetail = detail

        let result = try await sut.execute(id: 550)

        XCTAssertEqual(result.id, 550)
        XCTAssertEqual(result.title, "Fight Club")
        XCTAssertEqual(result.runtime, 139)
    }

    func test_execute_throwsWhenRepositoryFails() async {
        repository.shouldThrow = true

        do {
            _ = try await sut.execute(id: 1)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
}
