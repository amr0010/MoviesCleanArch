//
//  APIError.swift
//  Data
//
//  Created by Amr Magdy on 26/04/2026.
//

import Foundation

public enum APIError: LocalizedError {
    case invalidURL
    case httpError(statusCode: Int)
    case decodingFailed(Error)
    case noData
    case unknown(Error)

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid request URL."
        case .httpError(let code):
            return "Server returned status code \(code)."
        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .noData:
            return "No data received from server."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
