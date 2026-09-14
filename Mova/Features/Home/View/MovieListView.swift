//
//  MovieListView.swift
//  Mova
//
//  Created by Elchın on 09.09.26.
//

import SwiftUI

struct MovieListView: View {
    let title: String
    let movies: [Movie]

    var body: some View {
        MoviePosterGrid(movies: movies)
            .background(Color.white)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                searchToolbarItem
            }
    }

    private var searchToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.black)
        }
    }
}

#Preview {
    NavigationStack {
        MovieListView(title: "Top 10 Movies This Week", movies: [])
    }
}
