//
//  BackButton.swift
//  Mova
//
//  Created by Elchın on 04.09.26.
//

import SwiftUI

struct BackButton: View {
    var action: () -> Void = {}

    var body: some View {
        HStack {
            Button(action: action) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }
}
