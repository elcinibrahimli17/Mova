//
//  MovieVideo.swift
//  Mova
//
//  Created by Elchın on 25.09.26.
//


import Foundation

struct MovieVideo: Codable, Identifiable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String

    var youTubeThumbnailURL: URL? {
        guard site == "YouTube" else { return nil }
        return URL(string: "https://img.youtube.com/vi/\(key)/hqdefault.jpg")
    }
}

struct MovieVideoResponse: Codable {
    let results: [MovieVideo]
}