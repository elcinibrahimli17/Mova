//
//  MoviePosterCard.swift
//  Mova
//
//  Created by Elchın on 07.09.26.
//


import SwiftUI

struct MoviePosterCard: View {
    let movie: Movie

    var body: some View {
        ZStack(alignment: .topLeading) {
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
            .frame(width: 140, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(String(format: "%.1f", movie.voteAverage))
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(Color.red)
                .cornerRadius(6)
                .padding(6)
        }
    }
}