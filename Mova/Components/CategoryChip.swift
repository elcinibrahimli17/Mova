//
//  CategoryChip.swift
//  Mova
//
//  Created by Elchın on 10.09.26.
//

import SwiftUI

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Text(title)
        }
        .buttonStyle(CapsuleButtonStyle(
            background: isSelected ? .red : .white,
            foreground: isSelected ? .white : .black,
            borderColor: isSelected ? nil : Color.gray.opacity(0.3)
        ))
    }
}
