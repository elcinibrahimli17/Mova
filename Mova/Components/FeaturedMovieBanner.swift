//
//  FeaturedMovieBanner.swift
//  Mova
//
//  Created by Elchın on 07.09.26.
//


import SwiftUI

struct FeaturedMovieBanner: View {
    let movie: Movie
    private let bannerHeight: CGFloat = 560

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                backgroundImage(proxy: proxy)
                gradientOverlay(proxy: proxy)

                VStack {
                    topBar(proxy: proxy)
                    Spacer()
                    movieDetails
                }
            }
        }
        .frame(height: bannerHeight)
        .ignoresSafeArea(edges: .top)
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
                Image(systemName: "magnifyingglass")
                Image(systemName: "bell")
            }
            .foregroundColor(.white)
            .font(.system(size: 18))
        }
        .padding(.horizontal, 20)
        .padding(.top, proxy.safeAreaInsets.top + 8)
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
            Button(action: {}) {
                Label("Play", systemImage: "play.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }

            Button(action: {}) {
                Label("My List", systemImage: "plus")
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.15))
                    .foregroundColor(.white)
                    .overlay(Capsule().stroke(Color.white.opacity(0.6), lineWidth: 1))
                    .clipShape(Capsule())
            }
        }
        .padding(.top, 4)
    }
}
