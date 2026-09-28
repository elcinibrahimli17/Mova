//
//  FilterSheetView.swift
//  Mova
//
//  Created by Elchın on 10.09.26.
//

import SwiftUI

struct FilterSheetView: View {
    @EnvironmentObject var viewModel: ExploreViewModel
    @Environment(\.dismiss) private var dismiss
    private let onApplyFilter: () -> Void
    
    init(/*viewModel: ExploreViewModel, */onApplyFilter: @escaping () -> Void) {
//        self.viewModel = viewModel
        self.onApplyFilter = onApplyFilter
    }

    private let years = [2026, 2025, 2024, 2023, 2022]
    private let genres: [(id: Int, name: String)] = [
        (28, "Action"), (35, "Comedy"), (10749, "Romance"), (53, "Thriller"), (18, "Drama")
    ]

    var body: some View {
        VStack(spacing: 0) {
            title

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    genreSection
                    yearSection
                    sortSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }

            footerButtons
        }
        .padding(.top, 12)
    }

    private var title: some View {
        Text("Sort & Filter")
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.red)
            .padding(.bottom, 12)
    }

    private var genreSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Genre")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    CategoryChip(
                        title: "All Genres",
                        isSelected: viewModel.selectedGenreID == nil,
                        action: { viewModel.selectedGenreID = nil }
                    )

                    ForEach(genres, id: \.id) { genre in
                        CategoryChip(
                            title: genre.name,
                            isSelected: viewModel.selectedGenreID == genre.id,
                            action: { viewModel.selectedGenreID = genre.id }
                        )
                    }
                }
            }
        }
    }

    private var yearSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Time/Periods")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    CategoryChip(
                        title: "All Periods",
                        isSelected: viewModel.selectedYear == nil,
                        action: { viewModel.selectedYear = nil }
                    )

                    ForEach(years, id: \.self) { year in
                        CategoryChip(
                            title: String(year),
                            isSelected: viewModel.selectedYear == year,
                            action: { viewModel.selectedYear = year }
                        )
                    }
                }
            }
        }
    }

    private var sortSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sort")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)

            HStack(spacing: 10) {
                CategoryChip(
                    title: "Popularity",
                    isSelected: viewModel.sortBy == "popularity.desc",
                    action: { viewModel.sortBy = "popularity.desc" }
                )

                CategoryChip(
                    title: "Latest Release",
                    isSelected: viewModel.sortBy == "primary_release_date.desc",
                    action: { viewModel.sortBy = "primary_release_date.desc" }
                )
            }
        }
    }

    private var footerButtons: some View {
        HStack(spacing: 12) {
            Button(action: { viewModel.resetFilters() }) {
                Text("Reset")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(CapsuleButtonStyle(background: .red.opacity(0.1), foreground: .red))

            Button(action: {
                Task {
                    await viewModel.applyFilters()
                }
                dismiss()
//                onApplyFilter()
                
            }, label: {
                Text("Apply")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(CapsuleButtonStyle(background: .red))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}
