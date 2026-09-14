//
//  TMDBService.swift
//  Mova
//
//  Created by Elchın on 07.09.26.
//

import Foundation

enum TMDBError: LocalizedError {
    case invalidURL
    case missingAPIKey
    case requestFailed(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Yanlış sorğu ünvanı."
        case .missingAPIKey:
            return "TMDB API açarı tapılmadı."
        case .requestFailed(let message):
            return message
        }
    }
}

class TMDBService {

    private let baseURL = "https://api.themoviedb.org/3"

    private var apiKey: String {
        get throws {
            guard let key = Bundle.main.infoDictionary?["TMDB_API_KEY"] as? String,
                  !key.isEmpty else {
                throw TMDBError.missingAPIKey
            }
            return key
        }
    }

    private func execute(_ components: URLComponents) async throws -> [Movie] {
        guard let url = components.url else {
            throw TMDBError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw TMDBError.requestFailed("Server xətası.")
        }

        return try JSONDecoder().decode(MovieResponse.self, from: data).results
    }

    private func fetch(path: String) async throws -> [Movie] {
        let key = try apiKey

        guard var components = URLComponents(string: baseURL + path) else {
            throw TMDBError.invalidURL
        }
        components.queryItems = [
            URLQueryItem(name: "api_key", value: key),
            URLQueryItem(name: "language", value: "en-US")
        ]

        return try await execute(components)
    }

    func fetchTrendingToday() async throws -> [Movie] {
        try await fetch(path: "/trending/movie/day")
    }

    func fetchTrendingThisWeek() async throws -> [Movie] {
        try await fetch(path: "/trending/movie/week")
    }

    func fetchNowPlaying() async throws -> [Movie] {
        try await fetch(path: "/movie/now_playing")
    }

    func searchMovies(query: String) async throws -> [Movie] {
        let key = try apiKey

        guard var components = URLComponents(string: baseURL + "/search/movie") else {
            throw TMDBError.invalidURL
        }
        components.queryItems = [
            URLQueryItem(name: "api_key", value: key),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "query", value: query)
        ]

        return try await execute(components)
    }

    func discoverMovies(genreID: Int?, year: Int?, sortBy: String) async throws -> [Movie] {
        let key = try apiKey

        guard var components = URLComponents(string: baseURL + "/discover/movie") else {
            throw TMDBError.invalidURL
        }

        var queryItems = [
            URLQueryItem(name: "api_key", value: key),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "sort_by", value: sortBy)
        ]

        if let genreID {
            queryItems.append(URLQueryItem(name: "with_genres", value: String(genreID)))
        }
        if let year {
            queryItems.append(URLQueryItem(name: "primary_release_year", value: String(year)))
        }

        components.queryItems = queryItems

        return try await execute(components)
    }
    
    private struct MovieDetailResponse: Codable {
        let runtime: Int?
    }

    func fetchMovieRuntime(id: Int) async throws -> Int? {
        let key = try apiKey

        guard var components = URLComponents(string: baseURL + "/movie/\(id)") else {
            throw TMDBError.invalidURL
        }
        components.queryItems = [
            URLQueryItem(name: "api_key", value: key),
            URLQueryItem(name: "language", value: "en-US")
        ]

        guard let url = components.url else {
            throw TMDBError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw TMDBError.requestFailed("Server xətası.")
        }

        return try JSONDecoder().decode(MovieDetailResponse.self, from: data).runtime
    }
}
