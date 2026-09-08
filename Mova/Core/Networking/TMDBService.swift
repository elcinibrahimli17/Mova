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

    private func fetch(path: String) async throws -> MovieResponse {
        let key = try apiKey

        guard var components = URLComponents(string: baseURL + path) else {
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

        return try JSONDecoder().decode(MovieResponse.self, from: data)
    }

    // Home ekranindaki banner ucun (en trend olan filmler)
    func fetchTrendingToday() async throws -> [Movie] {
        try await fetch(path: "/trending/movie/day").results
    }

    // "Top 10 Movies This Week"
    func fetchTrendingThisWeek() async throws -> [Movie] {
        try await fetch(path: "/trending/movie/week").results
    }

    // "New Releases"
    func fetchNowPlaying() async throws -> [Movie] {
        try await fetch(path: "/movie/now_playing").results
    }
}
