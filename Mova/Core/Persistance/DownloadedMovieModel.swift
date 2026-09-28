//
//  DownloadedMovieModel.swift
//  Mova
//
//  Created by Elchın on 15.09.26.
//


import Foundation
import SwiftData

@Model
final class DownloadedMovieModel {
    @Attribute(.unique) var id: Int
    var title: String
    var overview: String
    var posterPath: String?
    var backdropPath: String?
    var voteAverage: Double
    var releaseDate: String?
    var genreIDs: [Int]
    var localImageFileName: String
    var runtimeMinutes: Int?
    var dateDownloaded: Date

    init(movie: Movie, localImageFileName: String, runtimeMinutes: Int?) {
        id = movie.id
        title = movie.title
        overview = movie.overview
        posterPath = movie.posterPath
        backdropPath = movie.backdropPath
        voteAverage = movie.voteAverage
        releaseDate = movie.releaseDate
        genreIDs = movie.genreIDs
        self.localImageFileName = localImageFileName
        self.runtimeMinutes = runtimeMinutes
        dateDownloaded = Date()
    }

    var movie: Movie {
        Movie(
            id: id,
            title: title,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath,
            voteAverage: voteAverage,
            releaseDate: releaseDate,
            genreIDs: genreIDs
        )
    }

    var formattedRuntime: String? {
        guard let runtimeMinutes else { return nil }
        let hours = runtimeMinutes / 60
        let minutes = runtimeMinutes % 60
        return hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"
    }
}
