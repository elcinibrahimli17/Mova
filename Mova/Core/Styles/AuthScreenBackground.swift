//
//  AuthScreenBackground.swift
//  Mova
//
//  Created by Elchın on 09.09.26.
//

import SwiftUI

struct AuthScreenBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
    }
}

extension View {
    func authScreenBackground() -> some View {
        modifier(AuthScreenBackground())
    }
}
