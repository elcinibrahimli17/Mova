//
//  TrailerLauncher.swift
//  Mova
//
//  Created by Elchın on 25.09.26.
//


import UIKit

@MainActor
enum TrailerLauncher {
    static func play(movieID: Int) async {
        guard let videos = try? await TMDBService().fetchVideos(movieID: movieID) else {
            return
        }

        let trailer = videos.first { $0.site == "YouTube" && $0.type == "Trailer" }
            ?? videos.first { $0.site == "YouTube" }

        guard let key = trailer?.key else { return }

        let appURL = URL(string: "youtube://\(key)")!
        let webURL = URL(string: "https://www.youtube.com/watch?v=\(key)")!

        if UIApplication.shared.canOpenURL(appURL) {
            await UIApplication.shared.open(appURL)
        } else {
            await UIApplication.shared.open(webURL)
        }
    }

    static func open(key: String) async {
        let appURL = URL(string: "youtube://\(key)")!
        let webURL = URL(string: "https://www.youtube.com/watch?v=\(key)")!

        if UIApplication.shared.canOpenURL(appURL) {
            await UIApplication.shared.open(appURL)
        } else {
            await UIApplication.shared.open(webURL)
        }
    }
}
