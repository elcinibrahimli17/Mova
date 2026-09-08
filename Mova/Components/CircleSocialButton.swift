//
//  CircleSocialButton.swift
//  Mova
//
//  Created by Elchın on 04.09.26.
//

import SwiftUI

struct CircleSocialButton: View {
    let icon: String
    let isSystemIcon: Bool
    var backgroundColor: Color? = nil
    var iconColor: Color = .black

    var body: some View {
        Button {
            
        } label: {
            Group {
                if isSystemIcon {
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(iconColor)
                } else {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                }
            }
            .frame(width: 56, height: 56)
            .background(backgroundColor ?? Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(backgroundColor == nil ? Color.gray.opacity(0.25) : Color.clear, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}
