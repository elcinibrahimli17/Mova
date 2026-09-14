//
//  AuthTitleStyle.swift
//  Mova
//
//  Created by Elchın on 09.09.26.
//

import SwiftUI

struct AuthTitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.black)
    }
}

extension View {
    func authTitleStyle() -> some View {
        modifier(AuthTitleStyle())
    }
}
