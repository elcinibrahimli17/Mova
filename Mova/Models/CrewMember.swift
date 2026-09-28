//
//  CrewMember.swift
//  Mova
//
//  Created by Elchın on 25.09.26.
//


import Foundation

struct CrewMember: Codable, Identifiable {
    let id: Int
    let name: String
    let job: String
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id, name, job
        case profilePath = "profile_path"
    }

    var profileURL: URL? {
        guard let profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w200\(profilePath)")
    }
}