//
//  BorderedCardStyle.swift
//  Mova
//
//  Created by Elchın on 09.09.26.
//

import SwiftUI

struct BorderedCardStyle: ViewModifier {
    var cornerRadius: CGFloat
    var borderColor: Color
    var lineWidth: CGFloat = 1

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: lineWidth)
            )
    }
}

extension View {
    func borderedCard(cornerRadius: CGFloat, borderColor: Color, lineWidth: CGFloat = 1) -> some View {
        modifier(BorderedCardStyle(cornerRadius: cornerRadius, borderColor: borderColor, lineWidth: lineWidth))
    }
}
