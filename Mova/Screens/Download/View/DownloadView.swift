//
//  DownloadView.swift
//  Mova
//
//  Created by Elchın on 14.09.26.
//


import SwiftUI
import SwiftData

struct DownloadView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DownloadedMovieModel.dateDownloaded, order: .reverse) private var downloads: [DownloadedMovieModel]
    @State private var pendingDeletion: DownloadedMovieModel?

    private func remove(_ download: DownloadedMovieModel) {
        DownloadService.deleteLocalImage(fileName: download.localImageFileName)
        modelContext.delete(download)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header

                if downloads.isEmpty {
                    Spacer()
                    emptyState
                    Spacer()
                } else {
                    downloadsList
                }
            }
            .background(Color.white)
            .toolbar(.hidden, for: .navigationBar)
            .sheet(item: $pendingDeletion) { download in
                DeleteDownloadSheet(
                    title: download.title,
                    runtimeText: download.formattedRuntime,
                    imageURL: DownloadService.localImageURL(fileName: download.localImageFileName),
                    onCancel: { pendingDeletion = nil },
                    onConfirm: {
                        remove(download)
                        pendingDeletion = nil
                    }
                )
                .presentationDetents([.fraction(0.4)])
            }
        }
    }

    private var header: some View {
        HStack {
            Text("M")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.red)

            Text("Download")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 12)
    }

    private var downloadsList: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(downloads) { download in
                    DownloadRow(
                        download: download,
                        onDelete: { pendingDeletion = download }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "arrow.down.circle")
                .font(.system(size: 80, weight: .thin))
                .foregroundColor(.gray.opacity(0.4))

            Text("No Downloads Yet")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.red)

            Text("Movies you download will appear here")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    DownloadView().modelContainer(for: [SavedMovie.self, DownloadedMovieModel.self], inMemory: true)
}
