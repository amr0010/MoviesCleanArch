//
//  AppDependencies.swift
//  MoviesCleanArch
//
//  Created by Amr Magdy on 26/04/2026.
//

import CoreData
import Domain
import Data

final class AppDependencies {
    let moviesListViewModel: MoviesListViewModel

    init() {
        let context = PersistenceController.shared.container.viewContext
        let store = CoreDataMoviesStore(context: context)
        let apiClient = APIClient(apiKey: APIKey.tmdb)

        let moviesRepo = DefaultMoviesRepository(apiClient: apiClient, store: store)
        let genresRepo = DefaultGenresRepository(apiClient: apiClient, store: store)

        moviesListViewModel = MoviesListViewModel(
            fetchMoviesUseCase: FetchTrendingMoviesUseCase(repository: moviesRepo),
            fetchGenresUseCase: FetchGenresUseCase(repository: genresRepo),
            fetchDetailUseCase: FetchMovieDetailUseCase(repository: moviesRepo)
        )
    }
}
