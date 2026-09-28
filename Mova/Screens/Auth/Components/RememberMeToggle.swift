//
//  RememberMeToggle.swift
//  Mova
//
//  Created by Elchın on 04.09.26.
//

import SwiftUI

struct RememberMeToggle: View {
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 8) {
            Button {
                isOn.toggle()
            } label: {
                Image(systemName: isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(isOn ? .red : .gray)
            }
            Text("Remember me")
                .font(.system(size: 14))
                .foregroundColor(.black)
        }
    }
}
