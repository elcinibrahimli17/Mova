//  SavedMovie.swift
//  Mova
//
//  Created by Elchın on 15.09.26.
//


import Foundation
import SwiftData

@Model
final class SavedMovie {
    @Attribute(.unique) var id: Int
    var title: String
    var overview: String
    var posterPath: String?
    var backdropPath: String?
    var voteAverage: Double
    var releaseDate: String?
    var genreIDs: [Int]
    var dateAdded: Date

    init(movie: Movie) {
        id = movie.id
        title = movie.title
        overview = movie.overview
        posterPath = movie.posterPath
        backdropPath = movie.backdropPath
        voteAverage = movie.voteAverage
        releaseDate = movie.releaseDate
        genreIDs = movie.genreIDs
        dateAdded = Date()
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
}
