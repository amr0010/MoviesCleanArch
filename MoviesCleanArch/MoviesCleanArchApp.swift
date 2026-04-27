//
//  MoviesCleanArchApp.swift
//  MoviesCleanArch
//
//  Created by Amr Magdy on 26/04/2026.
//

import SwiftUI

@main
struct MoviesCleanArchApp: App {
    @State private var dependencies = AppDependencies()

    init() {
        URLCache.shared = URLCache(
            memoryCapacity: 50 * 1024 * 1024,
            diskCapacity: 200 * 1024 * 1024
        )
    }

    var body: some Scene {
        WindowGroup {
            MoviesListView(viewModel: dependencies.moviesListViewModel)
        }
    }
}
