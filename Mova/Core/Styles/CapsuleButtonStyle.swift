//
//  CapsuleButtonStyle.swift
//  Mova
//
//  Created by Elchın on 09.09.26.
//


import SwiftUI

struct CapsuleButtonStyle: ButtonStyle {
    var background: Color
    var foreground: Color = .white
    var borderColor: Color? = nil

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .semibold))
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(background)
            .foregroundColor(foreground)
            .overlay {
                if let borderColor {
                    Capsule().stroke(borderColor, lineWidth: 1)
                }
            }
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}
