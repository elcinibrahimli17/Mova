//
//  ExploreView.swift
//  Mova
//
//  Created by Elchın on 10.09.26.
//

import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = ExploreViewModel()
    @EnvironmentObject var appState: AppStateController
    @FocusState private var isSearchFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchBar
                
                if !viewModel.activeFilters.isEmpty {
                    activeFilterChips
                }
                
                content
            }
            .background(Color.white)
            .toolbar(.hidden, for: .navigationBar)
            .task { await viewModel.loadInitialData() }
            .onChange(of: appState.shouldFocusSearch) { _, shouldFocus in
                if shouldFocus {
                    isSearchFieldFocused = true
                    appState.shouldFocusSearch = false
                }
            }
            .alert("Xəta", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
        .environmentObject(viewModel)
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
            
            filterView
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 12)
    }
    
    private var filterView: some View {
        NavigationLink(destination: FilterSheetView(/*viewModel: viewModel,*/onApplyFilter: {
//            Task {
//                await viewModel.applyFilters()
//            }
        })) {
            Image(systemName: "slider.horizontal.3")
                .font(.system(size: 18))
                .foregroundColor(.red)
                .frame(width: 52, height: 52)
                .background(Color.red.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
    
    private var activeFilterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.activeFilters) { filter in
                    HStack(spacing: 6) {
                        Text(filter.title)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)

                        Button {
                            viewModel.removeFilter(filter)
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
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
                MoviePosterGrid(movies: viewModel.exploreMovies, onReachEnd: {
                    viewModel.loadNextPageIfNeeded()
                })
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
