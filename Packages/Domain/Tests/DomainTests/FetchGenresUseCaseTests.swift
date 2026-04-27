//
//  FetchGenresUseCaseTests.swift
//  DomainTests
//
//  Created by Amr Magdy on 26/04/2026.
//

import XCTest
import Domain

final class FetchGenresUseCaseTests: XCTestCase {
    private var sut: FetchGenresUseCase!
    private var repository: MockGenresRepository!

    override func setUp() {
        super.setUp()
        repository = MockGenresRepository()
        sut = FetchGenresUseCase(repository: repository)
    }

    func test_execute_returnsGenresFromRepository() async throws {
        repository.stubbedGenres = [Genre(id: 28, name: "Action"), Genre(id: 35, name: "Comedy")]

        let result = try await sut.execute()

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.first?.name, "Action")
    }

    func test_execute_throwsWhenRepositoryFails() async {
        repository.shouldThrow = true

        do {
            _ = try await sut.execute()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
}
