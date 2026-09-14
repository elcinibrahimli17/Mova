//
//  ExploreView.swift
//  Mova
//
//  Created by Elchın on 10.09.26.
//

import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = ExploreViewModel()
    @FocusState private var isSearchFieldFocused: Bool
    @State private var showFilterSheet = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchBar

                if !viewModel.activeFilterTitles.isEmpty {
                    activeFilterChips
                }

                content
            }
            .background(Color.white)
            .toolbar(.hidden, for: .navigationBar)
            .task { await viewModel.loadInitialData() }
            .sheet(isPresented: $showFilterSheet) {
                FilterSheetView(viewModel: viewModel)
                    .presentationDetents([.fraction(0.75)])
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)

                TextField("Search", text: $viewModel.searchText)
                    .focused($isSearchFieldFocused)
                    .onChange(of: viewModel.searchText) { _, _ in
                        viewModel.onSearchTextChanged()
                    }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(14)

            Button(action: { showFilterSheet = true }) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 18))
                    .foregroundColor(.red)
                    .frame(width: 52, height: 52)
                    .background(Color.red.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 12)
    }

    private var activeFilterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.activeFilterTitles, id: \.self) { title in
                    Text(title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.red)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 12)
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.searchText.isEmpty {
            if isSearchFieldFocused {
                topSearchesList
            } else {
                MoviePosterGrid(movies: viewModel.exploreMovies)
            }
        } else if !viewModel.hasSearched {
            topSearchesList
        } else if viewModel.searchResults.isEmpty {
            VStack {
                Spacer()
                NotFoundView(query: viewModel.searchText)
                Spacer()
            }
        } else {
            MoviePosterGrid(movies: viewModel.searchResults)
        }
    }

    private var topSearchesList: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Top Searches")
                .sectionTitleStyle()
                .padding(.horizontal, 20)

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.topSearches) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                            SearchSuggestionRow(movie: movie)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.top, 8)
    }
}

#Preview {
    ExploreView()
}
