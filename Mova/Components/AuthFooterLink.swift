//
//  AuthFooterLink.swift
//  Mova
//
//  Created by Elchın on 04.09.26.
//

import SwiftUI

struct AuthFooterLink: View {
    let question: String
    let actionText: String

    var body: some View {
        HStack(spacing: 4) {
            Text(question)
                .foregroundColor(.gray)
            Text(actionText)
                .foregroundColor(.red)
                .fontWeight(.semibold)
        }
        .font(.system(size: 14))
        .padding(.bottom, 24)
    }
}
