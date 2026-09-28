//
//  ProfileMenuRow.swift
//  Mova
//
//  Created by Elchın on 08.09.26.
//


import SwiftUI

struct ProfileMenuRow: View {
    let icon: String
    let title: LocalizedStringKey
    var trailingText: String? = nil
    var tintColor: Color = .black
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(tintColor)
                    .frame(width: 28, height: 28)
                    .background(Color.gray.opacity(0.08))
                    .clipShape(Circle())

                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(tintColor)

                Spacer()

                if let trailingText {
                    Text(trailingText)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.gray.opacity(0.5))
            }
            .padding(.vertical, 10)
        }
        .buttonStyle(.plain)
    }
}
