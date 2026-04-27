//
//  CoreDataMoviesStore.swift
//  Data
//
//  Created by Amr Magdy on 26/04/2026.
//

import CoreData
import Domain

public final class CoreDataMoviesStore: @unchecked Sendable {
    private let context: NSManagedObjectContext

    public init(context: NSManagedObjectContext) {
        self.context = context
    }

    public func saveMovies(_ movies: [Movie], page: Int) throws {
        try context.performAndWait {
            let existing = try context.fetch(movieFetchRequest(page: page))
            existing.forEach { context.delete($0) }

            for movie in movies {
                let object = NSEntityDescription.insertNewObject(forEntityName: "CachedMovie", into: context)
                object.setValue(Int64(movie.id), forKey: "id")
                object.setValue(movie.title, forKey: "title")
                object.setValue(movie.posterPath, forKey: "posterPath")
                object.setValue(movie.releaseDate, forKey: "releaseDate")
                object.setValue(Int32(page), forKey: "page")
                object.setValue(try? JSONEncoder().encode(movie.genreIds), forKey: "genreIdsData")
            }

            try context.save()
        }
    }

    public func loadMovies(page: Int) throws -> [Movie] {
        try context.performAndWait {
            let objects = try context.fetch(movieFetchRequest(page: page))
            return objects.compactMap { movie(from: $0) }
        }
    }

    public func saveGenres(_ genres: [Genre]) throws {
        try context.performAndWait {
            let existing = try context.fetch(NSFetchRequest<NSManagedObject>(entityName: "CachedGenre"))
            existing.forEach { context.delete($0) }

            for genre in genres {
                let object = NSEntityDescription.insertNewObject(forEntityName: "CachedGenre", into: context)
                object.setValue(Int64(genre.id), forKey: "id")
                object.setValue(genre.name, forKey: "name")
            }

            try context.save()
        }
    }

    public func loadGenres() throws -> [Genre] {
        try context.performAndWait {
            let objects = try context.fetch(NSFetchRequest<NSManagedObject>(entityName: "CachedGenre"))
            return objects.compactMap { genre(from: $0) }
        }
    }
}

private extension CoreDataMoviesStore {
    func movieFetchRequest(page: Int) -> NSFetchRequest<NSManagedObject> {
        let request = NSFetchRequest<NSManagedObject>(entityName: "CachedMovie")
        request.predicate = NSPredicate(format: "page == %d", page)
        return request
    }

    func movie(from object: NSManagedObject) -> Movie? {
        guard let id = object.value(forKey: "id") as? Int64,
              let title = object.value(forKey: "title") as? String else { return nil }

        let posterPath = object.value(forKey: "posterPath") as? String
        let releaseDate = (object.value(forKey: "releaseDate") as? String) ?? ""
        let genreIds = (object.value(forKey: "genreIdsData") as? Data)
            .flatMap { try? JSONDecoder().decode([Int].self, from: $0) } ?? []

        return Movie(id: Int(id), title: title, posterPath: posterPath, releaseDate: releaseDate, genreIds: genreIds)
    }

    func genre(from object: NSManagedObject) -> Genre? {
        guard let id = object.value(forKey: "id") as? Int64,
              let name = object.value(forKey: "name") as? String else { return nil }
        return Genre(id: Int(id), name: name)
    }
}
