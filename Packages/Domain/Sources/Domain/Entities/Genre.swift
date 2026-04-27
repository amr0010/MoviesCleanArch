//
//  Genre.swift
//  Domain
//
//  Created by Amr Magdy on 26/04/2026.
//

public struct Genre: Identifiable, Hashable, Sendable {
    public let id: Int
    public let name: String

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
