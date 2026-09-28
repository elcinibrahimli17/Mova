//
//  DownloadService.swift
//  Mova
//
//  Created by Elchın on 15.09.26.
//

import Foundation

enum DownloadService {
    static func downloadsDirectory() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folder = documents.appendingPathComponent("Downloads", isDirectory: true)
        if !FileManager.default.fileExists(atPath: folder.path) {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        }
        return folder
    }

    static func localImageURL(fileName: String) -> URL {
        downloadsDirectory().appendingPathComponent(fileName)
    }

    static func fileSize(fileName: String) -> String {
        let url = localImageURL(fileName: fileName)
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: url.path),
              let size = attributes[.size] as? Int64 else {
            return "-"
        }
        return ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
    }

    static func downloadPosterImage(for movie: Movie) async throws -> String {
        guard let posterURL = movie.posterURL else {
            throw TMDBError.invalidURL
        }
        let (imageData, _) = try await URLSession.shared.data(from: posterURL)
        let fileName = "\(movie.id).jpg"
        try imageData.write(to: localImageURL(fileName: fileName))
        return fileName
    }

    static func deleteLocalImage(fileName: String) {
        try? FileManager.default.removeItem(at: localImageURL(fileName: fileName))
    }
}
