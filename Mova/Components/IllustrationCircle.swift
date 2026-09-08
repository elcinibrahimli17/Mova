//
//  IllustrationCircle.swift
//  Mova
//
//  Created by Elchın on 04.09.26.
//

import SwiftUI

struct IllustrationCircle: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.15))
                .frame(width: 220, height: 220)

            Image(systemName: "person.crop.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
                .foregroundColor(.gray.opacity(0.4))
        }
    }
}
