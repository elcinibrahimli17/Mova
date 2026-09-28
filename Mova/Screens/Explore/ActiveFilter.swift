//
//  ActiveFilter.swift
//  Mova
//
//  Created by Elchın on 24.09.26.
//


import Foundation

struct ActiveFilter: Identifiable, Hashable {
    enum Kind {
        case genre
        case year
        case sort
    }

    let kind: Kind
    let title: String

    var id: String { title }
}