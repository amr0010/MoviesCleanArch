//
//  DomainExtensions.swift
//  MoviesCleanArch
//
//  Created by Amr Magdy on 26/04/2026.
//

import Foundation
import Domain

extension Movie {
    var posterURL: URL? {
        posterPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w500\($0)") }
    }

    var releaseYear: String {
        String(releaseDate.prefix(4))
    }
}

extension MovieDetail {
    var posterURL: URL? {
        posterPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w500\($0)") }
    }

    var releaseMonthYear: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = inputFormatter.date(from: releaseDate) else { return releaseDate }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM yyyy"
        return outputFormatter.string(from: date)
    }

    var formattedRuntime: String {
        guard let runtime, runtime > 0 else { return "N/A" }
        let hours = runtime / 60
        let minutes = runtime % 60
        return hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"
    }

    var formattedBudget: String {
        guard budget > 0 else { return "N/A" }
        return budget.formatted(.currency(code: "USD").precision(.fractionLength(0)))
    }

    var formattedRevenue: String {
        guard revenue > 0 else { return "N/A" }
        return revenue.formatted(.currency(code: "USD").precision(.fractionLength(0)))
    }
}
