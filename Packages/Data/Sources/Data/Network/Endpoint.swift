//
//  Endpoint.swift
//  Data
//
//  Created by Amr Magdy on 26/04/2026.
//

import Foundation

struct Endpoint {
    let path: String
    var queryItems: [URLQueryItem] = []

    private static let baseURL = "https://api.themoviedb.org/3"

    var url: URL? {
        var components = URLComponents(string: Self.baseURL + path)
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }
        return components?.url
    }
}

extension Endpoint {
    static func genres() -> Endpoint {
        Endpoint(path: "/genre/movie/list")
    }

    static func discoverMovies(page: Int) -> Endpoint {
        Endpoint(path: "/discover/movie", queryItems: [
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "sort_by", value: "popularity.desc"),
            URLQueryItem(name: "page", value: "\(page)")
        ])
    }

    static func movieDetail(id: Int) -> Endpoint {
        Endpoint(path: "/movie/\(id)")
    }
}
