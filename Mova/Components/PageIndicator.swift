//
//  PageIndicator.swift
//  Mova
//
//  Created by Elchın on 04.09.26.
//

import SwiftUI

struct PageIndicator: View {
    let numberOfPages: Int
    let activeIndex: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                Capsule()
                    .fill(index == activeIndex ? Color.red : Color.white.opacity(0.4))
                    .frame(width: index == activeIndex ? 24 : 8, height: 8)
            }
        }
    }
}

#Preview {
    PageIndicator(numberOfPages: 3, activeIndex: 0)
        .padding()
        .background(Color.black)
}
