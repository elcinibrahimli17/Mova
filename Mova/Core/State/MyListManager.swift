//
//  MyListManager.swift
//  Mova
//
//  Created by Elchın on 10.09.26.
//

import Foundation
import Combine

@MainActor
final class MyListManager: ObservableObject {
    @Published private(set) var movies: [Movie] = []

    func isInList(_ movie: Movie) -> Bool {
        movies.contains(movie)
    }

    func toggle(_ movie: Movie) {
        if let index = movies.firstIndex(of: movie) {
            movies.remove(at: index)
        } else {
            movies.insert(movie, at: 0)
        }
    }

    func remove(_ movie: Movie) {
        movies.removeAll { $0.id == movie.id }
    }
}
