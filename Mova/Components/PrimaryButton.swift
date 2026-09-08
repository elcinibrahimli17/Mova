//
//  PrimaryButton.swift
//  Mova
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    var hasShadow: Bool = false
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color.red)
                .clipShape(Capsule())
                .shadow(color: hasShadow ? .red.opacity(0.35) : .clear, radius: 12, x: 0, y: 8)
        }
    }
}
