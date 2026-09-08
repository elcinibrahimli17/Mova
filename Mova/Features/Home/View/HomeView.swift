//
//  HomeView.swift
//  Mova
//
//  Created by Elchın on 07.09.26.
//


import SwiftUI

struct HomeView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        ScrollView {
            content
        }
        .background(Color.white)
        .overlay { loadingIndicator }
        .task {
            await viewModel.fetchHomeData()
        }
        .alert("Xəta", isPresented: .constant(viewModel.errorMessage != nil)) {
            errorAlertActions
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 24) {
            if let featured = viewModel.featuredMovie {
                FeaturedMovieBanner(movie: featured)
            }

            movieSection(title: "Top 10 Movies This Week", movies: viewModel.topMoviesThisWeek)
            movieSection(title: "New Releases", movies: viewModel.newReleases)
        }
        .padding(.bottom, 24)
    }

    @ViewBuilder
    private var loadingIndicator: some View {
        if viewModel.isLoading {
            ProgressView()
        }
    }

    @ViewBuilder
    private var errorAlertActions: some View {
        Button("OK") { viewModel.errorMessage = nil }
    }

    private func movieSection(title: String, movies: [Movie]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                Button("See all") {}
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.red)
            }
            .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(movies) { movie in
                        MoviePosterCard(movie: movie)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    HomeView(authViewModel: AuthViewModel())
}
