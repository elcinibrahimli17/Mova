//
//  TrailersListView.swift
//  Mova
//
//  Created by Elchın on 25.09.26.
//


import SwiftUI

struct TrailersListView: View {
    let videos: [MovieVideo]

    var body: some View {
        if videos.isEmpty {
            Text("Trailer tapılmadı.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding(.top, 20)
        } else {
            VStack(spacing: 16) {
                ForEach(videos.filter { $0.site == "YouTube" }) { video in
                    Button(action: { Task { await TrailerLauncher.open(key: video.key) } }) {
                        trailerRow(video)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, 16)
        }
    }

    private func trailerRow(_ video: MovieVideo) -> some View {
        HStack(spacing: 12) {
            ZStack {
                AsyncImage(url: video.youTubeThumbnailURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    default:
                        Color.gray.opacity(0.15)
                    }
                }
                .frame(width: 120, height: 68)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                Image(systemName: "play.circle.fill")
                    .font(.system(size: 26))
                    .foregroundColor(.white)
            }

            Text(video.name)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
                .lineLimit(2)

            Spacer()
        }
    }
}