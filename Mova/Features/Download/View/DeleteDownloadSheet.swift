//
//  DeleteDownloadSheet.swift
//  Mova
//
//  Created by Elchın on 14.09.26.
//


import SwiftUI
import UIKit

struct DeleteDownloadSheet: View {
    let title: String
    let runtimeText: String?
    let imageURL: URL
    var onCancel: () -> Void = {}
    var onConfirm: () -> Void = {}

    var body: some View {
        VStack(spacing: 20) {
            Text("Delete")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.red)
                .padding(.top, 16)

            Divider()

            Text("Are you sure you want to delete this movie download?")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            movieRow

            Divider()

            buttons
        }
    }

    private var movieRow: some View {
        HStack(spacing: 14) {
            Group {
                if let uiImage = UIImage(contentsOfFile: imageURL.path) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Color.gray.opacity(0.15)
                }
            }
            .frame(width: 70, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black)

                if let runtimeText {
                    Text(runtimeText)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
            }

            Spacer()
        }
        .padding(.horizontal, 24)
    }

    private var buttons: some View {
        HStack(spacing: 12) {
            Button(action: onCancel) {
                Text("Cancel")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(CapsuleButtonStyle(background: .red.opacity(0.1), foreground: .red))

            Button(action: onConfirm) {
                Text("Yes, Delete")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(CapsuleButtonStyle(background: .red))
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }
}
