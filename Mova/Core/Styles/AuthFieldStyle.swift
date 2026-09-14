//
//  AuthFieldStyle.swift
//  Mova
//
//  Created by Elchın on 09.09.26.
//

import SwiftUI

struct AuthFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
    }
}

extension View {
    func authFieldStyle() -> some View {
        modifier(AuthFieldStyle())
    }
}
