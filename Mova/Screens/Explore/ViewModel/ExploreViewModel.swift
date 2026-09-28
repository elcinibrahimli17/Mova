//
//  ExploreViewModel.swift
//  Mova
//
//  Created by Elchın on 10.09.26.
//

import Foundation
import Combine


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
    private var currentPage = 1
    private var canLoadMorePages = true
    private var isFetchingNextPage = false
    private var searchTask: Task<Void, Never>?

    var activeFilters: [ActiveFilter] {
        var filters: [ActiveFilter] = []

        if let genreID = selectedGenreID, let name = Movie.genreNames[genreID] {
            filters.append(ActiveFilter(kind: .genre, title: name))
        }
        if let year = selectedYear {
            filters.append(ActiveFilter(kind: .year, title: String(year)))
        }
        if sortBy == "primary_release_date.desc" {
            filters.append(ActiveFilter(kind: .sort, title: "Latest Release"))
        }

        return filters
    }

    func removeFilter(_ filter: ActiveFilter) {
        switch filter.kind {
        case .genre:
            selectedGenreID = nil
        case .year:
            selectedYear = nil
        case .sort:
            sortBy = "popularity.desc"
        }

        Task { await applyFilters() }
    }

    func loadInitialData() async {
        isLoading = true
        defer { isLoading = false }

        currentPage = 1
        canLoadMorePages = true

        do {
            topSearches = try await service.fetchTrendingThisWeek()

            exploreMovies = try await service.discoverMovies(
                genreID: selectedGenreID,
                year: selectedYear,
                sortBy: sortBy,
                page: currentPage
            )
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

        currentPage = 1
        canLoadMorePages = true

        do {
            let filteredMovies: [Movie] = try await service.discoverMovies(
                genreID: selectedGenreID,
                year: selectedYear,
                sortBy: sortBy,
                page: currentPage
            )
            await MainActor.run {
                exploreMovies = filteredMovies
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func resetFilters() {
        selectedGenreID = nil
        selectedYear = nil
        sortBy = "popularity.desc"
    }
    
    func loadNextPageIfNeeded() {
        guard !isFetchingNextPage, canLoadMorePages else { return }

        Task {
            isFetchingNextPage = true
            defer { isFetchingNextPage = false }

            let nextPage = currentPage + 1

            do {
                let newMovies = try await service.discoverMovies(
                    genreID: selectedGenreID,
                    year: selectedYear,
                    sortBy: sortBy,
                    page: nextPage
                )

                if newMovies.isEmpty {
                    canLoadMorePages = false
                } else {
                    exploreMovies.append(contentsOf: newMovies)
                    currentPage = nextPage
                }
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
