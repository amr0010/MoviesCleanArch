# MoviesCleanArch

An iOS movies browsing app built as a Jahez iOS interview task, showcasing Clean Architecture, SPM modularization, SwiftUI, and Combine.

---

## Features

- **Trending Movies List** — paginated grid powered by TMDB's discover endpoint
- **Local Search** — filter movies by title instantly without a network call
- **Genre Filter Chips** — tap one or more genres to narrow the list; deselect all to show everything
- **Movie Detail** — full poster, release date, genres, overview, homepage, budget, revenue, languages, status, and runtime
- **Offline Support** — Core Data cache serves content when the network is unavailable

---

## Architecture

Clean Architecture with MVVM for the presentation layer, split across SPM local packages:

```
Domain (pure Swift, no framework imports)
  └─ Entities: Movie, MovieDetail, Genre, MoviesPage
  └─ Repository Protocols
  └─ Use Cases: FetchTrendingMovies, FetchMovieDetail, FetchGenres

Data (depends on Domain)
  └─ Networking: APIClient, Endpoint, DTOs
  └─ Persistence: CoreDataMoviesStore
  └─ Repository Implementations: DefaultMoviesRepository, DefaultGenresRepository

Presentation — main app target (SwiftUI + Combine)
  └─ @Observable ViewModels
  └─ SwiftUI Views
  └─ DI: AppDependencies
```

**Dependency rule:** `Domain ← Data ← Presentation` — enforced at compile time by SPM.

---

## Tech Stack

- **SwiftUI** — declarative UI
- **Combine / async-await** — reactive data flow
- **Core Data** — offline persistence
- **Swift Package Manager** — local package modularization
- **TMDB API** — data source

---

## Requirements

- Xcode 15+
- iOS 17+

---

## Setup

1. Clone the repo
2. Open `MoviesCleanArch.xcodeproj`
3. Add the two local packages via **File → Add Package Dependencies → Add Local**:
   - `Packages/Domain`
   - `Packages/Data`
4. Link `Domain` and `Data` to the `MoviesCleanArch` target
5. Build and run on an iOS 17+ simulator or device

---

## API

Data is fetched from [The Movie Database (TMDB)](https://www.themoviedb.org/).

| Endpoint | Purpose |
|---|---|
| `GET /3/genre/movie/list` | Fetch all genres |
| `GET /3/discover/movie?sort_by=popularity.desc&page=n` | Paginated trending movies |
| `GET /3/movie/{id}` | Movie detail |
| `https://image.tmdb.org/t/p/w500{poster_path}` | Poster image |

---

## Tests

Unit tests live in three locations:

| Location | Coverage |
|---|---|
| `Packages/Domain/Tests/DomainTests/` | Use case success + error paths |
| `Packages/Data/Tests/DataTests/` | DTO JSON decoding and domain mapping |
| `MoviesCleanArchTests/` | ViewModel state transitions, search, and genre filtering |

Run package tests from the terminal:
```bash
swift test --package-path Packages/Domain
swift test --package-path Packages/Data
```
