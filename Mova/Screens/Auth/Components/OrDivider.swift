//
//  OrDivider.swift
//  Mova
//
//  Created by Elchın on 04.09.26.
//

import SwiftUI

struct OrDivider: View {
    let text: String

    var body: some View {
        HStack {
            Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1)
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(.gray)
            Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1)
        }
    }
}
