//
//  DownloadManager.swift
//  Mova
//
//  Created by Elchın on 14.09.26.
//

import Foundation
import Combine

@MainActor
final class DownloadManager: ObservableObject {
    @Published private(set) var downloads: [DownloadedMovie] = []
    @Published var downloadingMovieID: Int?

    private let service = TMDBService()
    private let metadataFileName = "downloads.json"

    private var downloadsDirectory: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folder = documents.appendingPathComponent("Downloads", isDirectory: true)
        if !FileManager.default.fileExists(atPath: folder.path) {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        }
        return folder
    }

    private var metadataURL: URL {
        downloadsDirectory.appendingPathComponent(metadataFileName)
    }

    init() {
        loadMetadata()
    }

    func isDownloaded(_ movie: Movie) -> Bool {
        downloads.contains { $0.movie.id == movie.id }
    }

    func localImageURL(for download: DownloadedMovie) -> URL {
        downloadsDirectory.appendingPathComponent(download.localImageFileName)
    }

    func fileSize(for download: DownloadedMovie) -> String {
        let url = localImageURL(for: download)
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: url.path),
              let size = attributes[.size] as? Int64 else {
            return "-"
        }
        return ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
    }

    func download(_ movie: Movie) async {
        guard !isDownloaded(movie), let posterURL = movie.posterURL else { return }

        downloadingMovieID = movie.id
        defer { downloadingMovieID = nil }

        do {
            let (imageData, _) = try await URLSession.shared.data(from: posterURL)
            let fileName = "\(movie.id).jpg"
            let fileURL = downloadsDirectory.appendingPathComponent(fileName)
            try imageData.write(to: fileURL)

            let runtime = try? await service.fetchMovieRuntime(id: movie.id)

            let downloaded = DownloadedMovie(movie: movie, localImageFileName: fileName, runtimeMinutes: runtime)
            downloads.insert(downloaded, at: 0)
            saveMetadata()
        } catch {
            
        }
    }

    func remove(_ download: DownloadedMovie) {
        try? FileManager.default.removeItem(at: localImageURL(for: download))
        downloads.removeAll { $0.id == download.id }
        saveMetadata()
    }

    private func saveMetadata() {
        guard let data = try? JSONEncoder().encode(downloads) else { return }
        try? data.write(to: metadataURL)
    }

    private func loadMetadata() {
        guard let data = try? Data(contentsOf: metadataURL),
              let saved = try? JSONDecoder().decode([DownloadedMovie].self, from: data) else { return }
        downloads = saved
    }
}
