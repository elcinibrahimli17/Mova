//
//  EmailField.swift
//  Mova
//
//  Created by Elchın on 04.09.26.
//


import SwiftUI

struct EmailField: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "envelope")
                .foregroundColor(.gray)
            TextField("Email", text: $text)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
        }
        .padding(16)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}
