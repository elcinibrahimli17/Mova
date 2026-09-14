//
//  DownloadedMovie.swift
//  Mova
//
//  Created by Elchın on 14.09.26.
//

import Foundation

struct DownloadedMovie: Identifiable, Codable {
    let movie: Movie
    let localImageFileName: String
    let runtimeMinutes: Int?

    var id: Int { movie.id }

    var formattedRuntime: String? {
        guard let runtimeMinutes else { return nil }
        let hours = runtimeMinutes / 60
        let minutes = runtimeMinutes % 60
        return hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"
    }
}
