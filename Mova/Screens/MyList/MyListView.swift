//
//  MyListView.swift
//  Mova
//
//  Created by Elchın on 10.09.26.
//

import SwiftUI
import SwiftData

struct MyListView: View {
    @Query(sort: \SavedMovie.dateAdded, order: .reverse) private var savedMovies: [SavedMovie]
    @State private var selectedCategory: String = "All Categories"

    private let categories = ["All Categories", "Movie", "TV Series"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header

                if savedMovies.isEmpty {
                    Spacer()
                    emptyState
                    Spacer()
                } else {
                    categoryFilter
                    MoviePosterGrid(movies: savedMovies.map(\.movie))
                }
            }
            .background(Color.white)
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var header: some View {
        HStack {
            Text("M")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.red)

            Text("My List")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)

            Spacer()

            Image(systemName: "magnifyingglass")
                .font(.system(size: 18))
                .foregroundColor(.black)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 12)
    }

    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(categories, id: \.self) { category in
                    CategoryChip(
                        title: category,
                        isSelected: category == selectedCategory,
                        action: { selectedCategory = category }
                    )
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 12)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "list.clipboard")
                .font(.system(size: 80, weight: .thin))
                .foregroundColor(.gray.opacity(0.4))

            Text("Your List is Empty")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.red)

            Text("It seems that you haven't added\nany movies to the list")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    MyListView().modelContainer(for: [SavedMovie.self, DownloadedMovieModel.self], inMemory: true)
}
