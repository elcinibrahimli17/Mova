//
//  SocialLoginButton.swift
//  Mova
//
//  Created by Elchın on 04.09.26.
//

import SwiftUI

struct SocialLoginButton: View {
    let icon: String
    let isSystemIcon: Bool
    let title: String
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if isSystemIcon {
                    Image(systemName: icon)
                        .foregroundColor(.black.opacity(0.7))
                } else {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }

                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .borderedCard(cornerRadius: 14, borderColor: Color.gray.opacity(0.25))
        }
    }
}
