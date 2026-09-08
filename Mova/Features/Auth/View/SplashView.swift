//
//  SplashView.swift
//  Mova
//
//  Created by Elchın on 03.09.26.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack(spacing: 200) {
            Spacer()
            Text("M")
                .font(.system(size: 150, weight: .bold))
                .foregroundColor(.red)
            ProgressView()
                .scaleEffect(2)
                .tint(.red)
            Spacer()
        }
    }
}

#Preview {
    SplashView()
}
