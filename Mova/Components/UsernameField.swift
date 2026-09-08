//
//  UsernameField.swift
//  Mova
//
//  Created by Elchın on 07.09.26.
//


import SwiftUI

struct UsernameField: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "person")
                .foregroundColor(.gray)
            TextField("Usernamed", text: $text)
                .autocapitalization(.none)
        }
        .padding(16)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}
