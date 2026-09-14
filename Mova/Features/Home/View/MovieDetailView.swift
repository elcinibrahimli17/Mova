//
//  MovieDetailView.swift
//  Mova
//
//  Created by Elchın on 09.09.26.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @EnvironmentObject var myListManager: MyListManager
    @EnvironmentObject var downloadManager: DownloadManager
    @Environment(\.dismiss) private var dismiss
    
    private let backdropHeight: CGFloat = 340
    private let posterWidth: CGFloat = 120
    private let posterHeight: CGFloat = 170
    
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
        .toolbar(.hidden, for: .navigationBar)
    }
    
    private var backdropSection: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottomLeading) {
                backgroundImage(proxy: proxy)
                gradientOverlay
                topBar
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
    
    private var topBar: some View {
        VStack {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black.opacity(0.35))
                        .clipShape(Circle())
                }

                Spacer()

                downloadButton
            }
            .padding(.horizontal, 20)
            .padding(.top, 56)

            Spacer()
        }
    }

    private var downloadButton: some View {
            Button(action: { Task { await downloadManager.download(movie) } }) {
                Group {
                    if downloadManager.downloadingMovieID == movie.id {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: downloadManager.isDownloaded(movie) ? "checkmark.circle.fill" : "arrow.down.circle")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .padding(10)
                .background(Color.black.opacity(0.35))
                .clipShape(Circle())
            }
            .disabled(downloadManager.isDownloaded(movie) || downloadManager.downloadingMovieID == movie.id)
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
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
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
            Button(action: {}) {
                Label("Play", systemImage: "play.fill")
            }
            .buttonStyle(CapsuleButtonStyle(background: .red))
            
            Button(action: { myListManager.toggle(movie) }) {
                Label(
                    myListManager.isInList(movie) ? "Added to List" : "My List",
                    systemImage: myListManager.isInList(movie) ? "checkmark" : "plus"
                )
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
}
