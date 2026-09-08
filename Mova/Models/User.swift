//
//  User.swift
//  Mova
//
//  Created by Elchın on 07.09.26.
//


import Foundation

struct User: Identifiable, Codable {
    let id: String       
    let username: String
    let email: String
    let createdAt: Date
}
