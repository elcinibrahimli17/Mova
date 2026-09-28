//
//  CreditsResponse.swift
//  Mova
//
//  Created by Elchın on 25.09.26.
//


struct CreditsResponse: Codable {
    let cast: [CastMember]
    let crew: [CrewMember]
}