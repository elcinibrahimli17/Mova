//
//  NotFoundView.swift
//  Mova
//
//  Created by Elchın on 10.09.26.
//

import SwiftUI

struct NotFoundView: View {
    let query: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "questionmark.folder")
                .font(.system(size: 70, weight: .thin))
                .foregroundColor(.gray.opacity(0.3))

            Text("Not Found")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.red)

            Text("Sorry, the keyword you entered could not be found. Try to check again or search with other keywords.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}
