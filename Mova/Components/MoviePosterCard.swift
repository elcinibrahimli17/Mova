//
//  MoviePosterCard.swift
//  Mova
//
//  Created by Elchın on 07.09.26.
//


import SwiftUI

struct MoviePosterCard: View {
    let movie: Movie
    var width: CGFloat = 140
    var height: CGFloat = 200

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
            .frame(width: width, height: height)
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
