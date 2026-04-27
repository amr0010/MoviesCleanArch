//
//  FetchTrendingMoviesUseCaseTests.swift
//  DomainTests
//
//  Created by Amr Magdy on 26/04/2026.
//

import XCTest
import Domain

final class FetchTrendingMoviesUseCaseTests: XCTestCase {
    private var sut: FetchTrendingMoviesUseCase!
    private var repository: MockMoviesRepository!

    override func setUp() {
        super.setUp()
        repository = MockMoviesRepository()
        sut = FetchTrendingMoviesUseCase(repository: repository)
    }

    func test_execute_returnsPageFromRepository() async throws {
        let movie = Movie(id: 1, title: "Fight Club", posterPath: nil, releaseDate: "1999-10-15", genreIds: [18])
        repository.stubbedPage = MoviesPage(movies: [movie], currentPage: 1, totalPages: 5)

        let result = try await sut.execute(page: 1)

        XCTAssertEqual(result.movies.count, 1)
        XCTAssertEqual(result.movies.first?.title, "Fight Club")
        XCTAssertEqual(result.totalPages, 5)
    }

    func test_execute_throwsWhenRepositoryFails() async {
        repository.shouldThrow = true

        do {
            _ = try await sut.execute(page: 1)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
}
