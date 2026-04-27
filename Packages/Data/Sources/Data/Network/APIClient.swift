//
//  APIClient.swift
//  Data
//
//  Created by Amr Magdy on 26/04/2026.
//

import Foundation

public final class APIClient: Sendable {
    private let session: URLSession
    private let apiKey: String

    public init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard let url = endpoint.url else { throw APIError.invalidURL }

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "accept")

        let (data, response) = try await session.data(for: urlRequest)

        guard let http = response as? HTTPURLResponse else { throw APIError.noData }
        guard (200..<300).contains(http.statusCode) else {
            throw APIError.httpError(statusCode: http.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed(error)
        }
    }
}
