//
//  HomeViewModel.swift
//  Mova
//
//  Created by Elchın on 07.09.26.
//


import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {

    @Published var featuredMovie: Movie?
    @Published var topMoviesThisWeek: [Movie] = []
    @Published var newReleases: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = TMDBService()

    func fetchHomeData() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            async let trending = service.fetchTrendingThisWeek()
            async let nowPlaying = service.fetchNowPlaying()

            let topMovies = try await trending
            let releases = try await nowPlaying

            self.topMoviesThisWeek = topMovies
            self.newReleases = releases
            self.featuredMovie = topMovies.first
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
