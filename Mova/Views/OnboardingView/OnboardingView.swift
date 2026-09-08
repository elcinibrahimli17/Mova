//
//  OnboardingView.swift
//  Mova
//
//  Created by Elchın on 03.09.26.
//

import SwiftUI

struct OnboardingView: View {
    
    var onGetStarted: () -> Void = {}

    var body: some View {
        ZStack {
            Image(.splashmovie)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            LinearGradient(
                colors: [
                    Color.clear,
                    Color.black.opacity(0.55),
                    Color.black.opacity(0.95)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                VStack(spacing: 8) {
                    Text("Welcome to Mova")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)

                    Text("The best movie streaming app of the century\nto make your days great!")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.75))
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                }
                .padding(.horizontal, 28)

                PageIndicator(numberOfPages: 3, activeIndex: 0)

                PrimaryButton(title: "Get Started", hasShadow: true, action: onGetStarted)
                    .padding(.horizontal, 24)
                    .padding(.top, 4)
                    .padding(.bottom, 24)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    OnboardingView()
}
