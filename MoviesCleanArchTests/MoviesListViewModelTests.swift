//
//  MoviesListViewModelTests.swift
//  MoviesCleanArchTests
//
//  Created by Amr Magdy on 26/04/2026.
//

import XCTest
import Domain
@testable import MoviesCleanArch

@MainActor
final class MoviesListViewModelTests: XCTestCase {
    private var sut: MoviesListViewModel!
    private var moviesRepo: MockMoviesRepository!
    private var genresRepo: MockGenresRepository!

    override func setUp() {
        super.setUp()
        moviesRepo = MockMoviesRepository()
        genresRepo = MockGenresRepository()
        sut = MoviesListViewModel(
            fetchMoviesUseCase: FetchTrendingMoviesUseCase(repository: moviesRepo),
            fetchGenresUseCase: FetchGenresUseCase(repository: genresRepo),
            fetchDetailUseCase: FetchMovieDetailUseCase(repository: moviesRepo)
        )
    }

    func test_loadInitial_populatesMoviesAndGenres() async {
        moviesRepo.stubbedPage = MoviesPage(
            movies: [Movie(id: 1, title: "Inception", posterPath: nil, releaseDate: "2010-07-16", genreIds: [28])],
            currentPage: 1, totalPages: 3
        )
        genresRepo.stubbedGenres = [Genre(id: 28, name: "Action")]

        await sut.loadInitial()

        XCTAssertEqual(sut.movies.count, 1)
        XCTAssertEqual(sut.genres.count, 1)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }

    func test_loadInitial_setsErrorMessageOnFailure() async {
        moviesRepo.shouldThrow = true

        await sut.loadInitial()

        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.movies.isEmpty)
        XCTAssertFalse(sut.isLoading)
    }

    func test_filteredMovies_bySearchText_returnsMatchingMovies() async {
        moviesRepo.stubbedPage = MoviesPage(movies: [
            Movie(id: 1, title: "Avatar", posterPath: nil, releaseDate: "2009-12-18", genreIds: []),
            Movie(id: 2, title: "Batman", posterPath: nil, releaseDate: "2022-03-04", genreIds: [])
        ], currentPage: 1, totalPages: 1)
        await sut.loadInitial()

        sut.searchText = "ava"

        XCTAssertEqual(sut.filteredMovies.count, 1)
        XCTAssertEqual(sut.filteredMovies.first?.title, "Avatar")
    }

    func test_filteredMovies_byGenre_returnsMatchingMovies() async {
        moviesRepo.stubbedPage = MoviesPage(movies: [
            Movie(id: 1, title: "Action Movie", posterPath: nil, releaseDate: "2024-01-01", genreIds: [28]),
            Movie(id: 2, title: "Comedy Movie", posterPath: nil, releaseDate: "2024-01-01", genreIds: [35])
        ], currentPage: 1, totalPages: 1)
        await sut.loadInitial()

        sut.selectedGenreIds = [28]

        XCTAssertEqual(sut.filteredMovies.count, 1)
        XCTAssertEqual(sut.filteredMovies.first?.id, 1)
    }

    func test_filteredMovies_noSelection_returnsAll() async {
        moviesRepo.stubbedPage = MoviesPage(movies: [
            Movie(id: 1, title: "Movie A", posterPath: nil, releaseDate: "2024-01-01", genreIds: [28]),
            Movie(id: 2, title: "Movie B", posterPath: nil, releaseDate: "2024-01-01", genreIds: [35])
        ], currentPage: 1, totalPages: 1)
        await sut.loadInitial()

        XCTAssertEqual(sut.filteredMovies.count, 2)
    }
}
