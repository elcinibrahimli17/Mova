//
//  PasswordField.swift
//  Mova
//
//  Created by Elchın on 04.09.26.
//

import SwiftUI

struct PasswordField: View {
    @Binding var text: String
    @Binding var isVisible: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "lock")
                .foregroundColor(.gray)

            if isVisible {
                TextField("Password", text: $text)
            } else {
                SecureField("Password", text: $text)
            }

            Button {
                isVisible.toggle()
            } label: {
                Image(systemName: isVisible ? "eye" : "eye.slash")
                    .foregroundColor(.gray)
            }
        }
        .padding(16)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}
