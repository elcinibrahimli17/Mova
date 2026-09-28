//
//  CommentsPlaceholderView.swift
//  Mova
//
//  Created by Elchın on 25.09.26.
//


import SwiftUI

struct CommentsPlaceholderView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "bubble.left")
                .font(.system(size: 32))
                .foregroundColor(.gray.opacity(0.4))

            Text("Hələlik komment yoxdur.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 32)
    }
}