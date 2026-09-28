//
//  MovieDetailView.swift
//  Mova
//
//  Created by Elchın on 09.09.26.
//

import SwiftUI
import SwiftData

struct MovieDetailView: View {
    let movie: Movie
    @Environment(\.dismiss) private var dismiss

    private let backdropHeight: CGFloat = 340
    private let posterWidth: CGFloat = 120
    private let posterHeight: CGFloat = 170

    @Environment(\.modelContext) private var modelContext
    @Query private var savedMovies: [SavedMovie]
    @Query private var downloadedMovies: [DownloadedMovieModel]
    @State private var isDownloading = false
    @State private var isLoadingTrailer = false
    @State private var director: CrewMember?
    @State private var cast: [CastMember] = []
    @State private var selectedTab: DetailTab = .trailers
    @State private var videos: [MovieVideo] = []
    @State private var recommendations: [Movie] = []

    private var isSaved: Bool {
        savedMovies.contains { $0.id == movie.id }
    }

    private var isDownloaded: Bool {
        downloadedMovies.contains { $0.id == movie.id }
    }

    private func toggleMyList() {
        if let existing = savedMovies.first(where: { $0.id == movie.id }) {
            modelContext.delete(existing)
        } else {
            modelContext.insert(SavedMovie(movie: movie))
        }
    }

    private func downloadMovie() async {
        guard !isDownloaded else { return }
        isDownloading = true
        defer { isDownloading = false }

        do {
            let fileName = try await DownloadService.downloadPosterImage(for: movie)
            let runtime = try? await TMDBService().fetchMovieRuntime(id: movie.id)
            modelContext.insert(DownloadedMovieModel(movie: movie, localImageFileName: fileName, runtimeMinutes: runtime))
        } catch {
            // Yükləmə uğursuz olarsa heç nə əlavə olunmur
        }
    }
    
    private func loadCredits() async {
        guard let credits = try? await TMDBService().fetchCredits(movieID: movie.id) else {
            return
        }
        director = credits.crew.first { $0.job == "Director" }
        cast = Array(credits.cast.prefix(10))
    }
    
    private func loadTabsData() async {
        async let videosResult = try? TMDBService().fetchVideos(movieID: movie.id)
        async let recommendationsResult = try? TMDBService().fetchRecommendations(movieID: movie.id)

        videos = await videosResult ?? []
        recommendations = await recommendationsResult ?? []
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                backdropSection
                    .padding(.bottom, posterHeight / 2 + 16)

                infoSection
            }
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .top)
        .tint(.white)
        .task {
            await loadCredits()
            await loadTabsData()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                downloadButton
            }
        }
    }

    private var backdropSection: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottomLeading) {
                backgroundImage(proxy: proxy)
                gradientOverlay
                posterOverlay
            }
        }
        .frame(height: backdropHeight)
    }

    private func backgroundImage(proxy: GeometryProxy) -> some View {
        AsyncImage(url: movie.backdropURL ?? movie.posterURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            default:
                Color.gray.opacity(0.15)
            }
        }
        .frame(width: proxy.size.width, height: backdropHeight)
        .clipped()
    }

    private var gradientOverlay: some View {
        LinearGradient(
            colors: [.black.opacity(0.75), .black.opacity(0.1), .clear],
            startPoint: .bottom,
            endPoint: .center
        )
        .frame(height: backdropHeight)
    }

    private var downloadButton: some View {
        Button(action: { Task { await downloadMovie() } }) {
            Group {
                if isDownloading {
                    ProgressView()
                } else {
                    Image(systemName: isDownloaded ? "checkmark.circle.fill" : "arrow.down.circle")
                }
            }
        }
        .disabled(isDownloaded || isDownloading)
    }

    private var posterOverlay: some View {
        HStack {
            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                default:
                    Color.gray.opacity(0.15)
                }
            }
            .frame(width: posterWidth, height: posterHeight)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white, lineWidth: 3)
            )
            .offset(y: posterHeight / 2)
            .padding(.leading, 20)

            Spacer()
        }
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            titleBlock
            actionButtons
            overviewBlock

            if director != nil || !cast.isEmpty {
                castCrewSection
            }

            tabsSection
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
    }

    private var tabsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            DetailTabSelector(selectedTab: $selectedTab)
                .padding(.horizontal, -20)

            Group {
                switch selectedTab {
                case .trailers:
                    TrailersListView(videos: videos)
                case .moreLikeThis:
                    MoviePosterGrid(movies: recommendations)
                        .frame(height: CGFloat(((recommendations.count + 1) / 2)) * 260)
                        .padding(.horizontal, -20)
                case .comments:
                    CommentsPlaceholderView()
                }
            }
        }
    }

    private var castCrewSection: some View {
        CastCrewRow(director: director, cast: cast)
            .padding(.horizontal, -20)
    }

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(movie.title)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.black)

            HStack(spacing: 10) {
                Label(String(format: "%.1f", movie.voteAverage), systemImage: "star.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.orange)

                if let year = releaseYear {
                    Text(year)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
            }

            if !movie.genreText.isEmpty {
                Text(movie.genreText)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button(action: {
                Task {
                    isLoadingTrailer = true
                    await TrailerLauncher.play(movieID: movie.id)
                    isLoadingTrailer = false
                }
            }) {
                if isLoadingTrailer {
                    ProgressView()
                        .tint(.white)
                } else {
                    Label("Play", systemImage: "play.fill")
                }
            }
            .buttonStyle(CapsuleButtonStyle(background: .red))
            .disabled(isLoadingTrailer)

            Button(action: toggleMyList) {
                Label(isSaved ? "Added to List" : "My List", systemImage: isSaved ? "checkmark" : "plus")
            }
            .buttonStyle(CapsuleButtonStyle(background: .gray.opacity(0.1), foreground: .black))
        }
    }
    
    private var overviewBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Overview")
                .sectionTitleStyle()

            Text(movie.overview.isEmpty ? "Təsvir mövcud deyil." : movie.overview)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .lineSpacing(4)
        }
    }

    private var releaseYear: String? {
        guard let releaseDate = movie.releaseDate, releaseDate.count >= 4 else { return nil }
        return String(releaseDate.prefix(4))
    }
}

#Preview {
    NavigationStack {
        MovieDetailView(movie: Movie(
            id: 1,
            title: "Sample Movie",
            overview: "This is a sample overview text for preview purposes.",
            posterPath: nil,
            backdropPath: nil,
            voteAverage: 8.4,
            releaseDate: "2026-01-01",
            genreIDs: [28, 12]
        ))
    }
    .modelContainer(for: [SavedMovie.self, DownloadedMovieModel.self], inMemory: true)
}
