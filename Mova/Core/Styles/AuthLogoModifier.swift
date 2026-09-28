//
//  AuthLogoModifier.swift
//  Mova
//
//  Created by Elchın on 21.09.26.
//

import SwiftUI

struct AuthLogoModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 130, weight: .heavy))
            .foregroundColor(.red)
    }
}

extension View {
    func authLogoModifier() -> some View {
        modifier(AuthLogoModifier())
    }
}
