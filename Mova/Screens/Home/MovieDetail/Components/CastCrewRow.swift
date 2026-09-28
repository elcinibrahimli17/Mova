//
//  CastCrewRow.swift
//  Mova
//
//  Created by Elchın on 25.09.26.
//


import SwiftUI

struct CastCrewRow: View {
    let director: CrewMember?
    let cast: [CastMember]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                if let director {
                    PersonAvatar(name: director.name, role: "Director", profileURL: director.profileURL)
                }

                ForEach(cast) { member in
                    PersonAvatar(name: member.name, role: "Cast", profileURL: member.profileURL)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

private struct PersonAvatar: View {
    let name: String
    let role: String
    let profileURL: URL?

    var body: some View {
        HStack(spacing: 10) {
            AsyncImage(url: profileURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                default:
                    Color.gray.opacity(0.15)
                }
            }
            .frame(width: 44, height: 44)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(1)

                Text(role)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
        }
    }
}