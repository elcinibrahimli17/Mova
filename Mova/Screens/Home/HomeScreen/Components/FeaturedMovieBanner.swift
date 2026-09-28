//
//  FeaturedMovieBanner.swift
//  Mova
//
//  Created by Elchın on 07.09.26.
//


import SwiftUI
import SwiftData

struct FeaturedMovieBanner: View {
    let movie: Movie
    private let bannerHeight: CGFloat = 560
    
    @Environment(\.modelContext) private var modelContext
    @Query private var savedMovies: [SavedMovie]
    @EnvironmentObject var appState: AppStateController

    private var isSaved: Bool {
        savedMovies.contains { $0.id == movie.id }
    }
    @State private var isLoadingTrailer = false

    private func toggleMyList() {
        if let existing = savedMovies.first(where: { $0.id == movie.id }) {
            modelContext.delete(existing)
        } else {
            modelContext.insert(SavedMovie(movie: movie))
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                backgroundImage(proxy: proxy)
                gradientOverlay(proxy: proxy)
                
                VStack(alignment: .leading) {
                    topBar(proxy: proxy)
                    Spacer()
                    movieDetails
                }
            }
        }
        .frame(height: bannerHeight)
        .scaledToFill()
        .ignoresSafeArea()
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
        .frame(width: proxy.size.width, height: bannerHeight + proxy.safeAreaInsets.top)
        .clipped()
    }
    
    private func gradientOverlay(proxy: GeometryProxy) -> some View {
        LinearGradient(
            colors: [.black.opacity(0.85), .black.opacity(0.1), .clear],
            startPoint: .bottom,
            endPoint: .center
        )
        .frame(height: bannerHeight + proxy.safeAreaInsets.top)
    }
    
    private func topBar(proxy: GeometryProxy) -> some View {
        HStack {
            Text("M")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.red)

            Spacer()

            HStack(spacing: 16) {
                Button {
                    appState.selectedTab = .explore
                    appState.shouldFocusSearch = true
                } label: {
                    Image(systemName: "magnifyingglass")
                }
            }
            .foregroundColor(.white)
            .font(.system(size: 18))
        }
        .padding(.horizontal, 20)
        .padding(.top, proxy.safeAreaInsets.top + 50)
    }
    
    private var movieDetails: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(movie.title)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)
            
            if !movie.genreText.isEmpty {
                Text(movie.genreText)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            actionButtons
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
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
                Label(isSaved ? "Added" : "My List", systemImage: isSaved ? "checkmark" : "plus")
            }
            .buttonStyle(CapsuleButtonStyle(background: .white.opacity(0.15), borderColor: .white.opacity(0.6)))
        }
        .padding(.top, 4)
    }
}
