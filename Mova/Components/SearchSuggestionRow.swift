//
//  SearchSuggestionRow.swift
//  Mova
//
//  Created by Elchın on 10.09.26.
//

import SwiftUI

struct SearchSuggestionRow: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: 14) {
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
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Text(movie.title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.black)

            Spacer()
        }
    }
}
