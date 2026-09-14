//
//  DownloadRow.swift
//  Mova
//
//  Created by Elchın on 14.09.26.
//

import SwiftUI
import UIKit

struct DownloadRow: View {
    @EnvironmentObject var downloadManager: DownloadManager
    let download: DownloadedMovie
    var onDelete: () -> Void = {}

    var body: some View {
        HStack(spacing: 14) {
            posterImage
            infoBlock
            Spacer()

            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
    }

    private var posterImage: some View {
        Group {
            if let uiImage = UIImage(contentsOfFile: downloadManager.localImageURL(for: download).path) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Color.gray.opacity(0.15)
            }
        }
        .frame(width: 90, height: 60)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            Image(systemName: "play.circle.fill")
                .foregroundColor(.white)
                .font(.system(size: 20))
        )
    }

    private var infoBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(download.movie.title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.black)
                .lineLimit(1)

            if let runtime = download.formattedRuntime {
                Text(runtime)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }

            Text(downloadManager.fileSize(for: download))
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.red)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Color.red.opacity(0.1))
                .cornerRadius(6)
        }
    }
}
