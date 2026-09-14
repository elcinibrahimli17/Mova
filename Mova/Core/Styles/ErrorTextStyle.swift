//
//  ErrorTextStyle.swift
//  Mova
//
//  Created by Elchın on 09.09.26.
//


import SwiftUI

struct ErrorTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 13))
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
    }
}

extension View {
    func errorTextStyle() -> some View {
        modifier(ErrorTextStyle())
    }
}