//
//  ExploreViewModel.swift
//  Mova
//
//  Created by Elchın on 10.09.26.
//

import Foundation
import Combine

@MainActor
final class ExploreViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var exploreMovies: [Movie] = []
    @Published var topSearches: [Movie] = []
    @Published var searchResults: [Movie] = []
    @Published var hasSearched: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    @Published var selectedGenreID: Int?
    @Published var selectedYear: Int?
    @Published var sortBy: String = "popularity.desc"

    private let service = TMDBService()
    private var searchTask: Task<Void, Never>?

    var activeFilterTitles: [String] {
        var titles: [String] = []

        if let genreID = selectedGenreID, let name = Movie.genreNames[genreID] {
            titles.append(name)
        }
        if let year = selectedYear {
            titles.append(String(year))
        }
        if sortBy == "primary_release_date.desc" {
            titles.append("Latest Release")
        }

        return titles
    }

    func loadInitialData() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let trending = try await service.fetchTrendingThisWeek()
            exploreMovies = trending
            topSearches = trending
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func onSearchTextChanged() {
        searchTask?.cancel()
        hasSearched = false

        let trimmed = searchText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            searchResults = []
            return
        }

        searchTask = Task {
            try? await Task.sleep(nanoseconds: 400_000_000)
            guard !Task.isCancelled else { return }
            await performSearch()
        }
    }

    private func performSearch() async {
        do {
            searchResults = try await service.searchMovies(query: searchText)
        } catch {
            errorMessage = error.localizedDescription
        }
        hasSearched = true
    }

    func applyFilters() async {
        isLoading = true
        defer { isLoading = false }

        do {
            exploreMovies = try await service.discoverMovies(
                genreID: selectedGenreID,
                year: selectedYear,
                sortBy: sortBy
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func resetFilters() {
        selectedGenreID = nil
        selectedYear = nil
        sortBy = "popularity.desc"
    }
}
