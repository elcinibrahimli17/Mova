//
//  MoviePosterGrid.swift
//  Mova
//
//  Created by Elchın on 10.09.26.
//

import SwiftUI

struct MoviePosterGrid: View {
    let movies: [Movie]
    var onReachEnd: (() -> Void)? = nil

    private let horizontalPadding: CGFloat = 20
    private let columnSpacing: CGFloat = 16

    var body: some View {
        GeometryReader { proxy in
            grid(proxy: proxy)
        }
    }

    private func grid(proxy: GeometryProxy) -> some View {
        let cardWidth = max((proxy.size.width - horizontalPadding * 2 - columnSpacing) / 2, 1)
        let cardHeight = cardWidth * 1.45

        return ScrollView {
            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: columnSpacing), GridItem(.flexible())],
                spacing: 16
            ) {
                ForEach(movies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        MoviePosterCard(movie: movie, width: cardWidth, height: cardHeight)
                    }
                    .buttonStyle(.plain)
                    .onAppear {
                        if movie.id == movies.last?.id {
                            onReachEnd?()
                        }
                    }
                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.top, 16)
            .padding(.bottom, 24)
        }
    }
}
