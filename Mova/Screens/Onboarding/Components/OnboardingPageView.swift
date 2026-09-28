//
//  OnboardingPageView.swift
//  Mova
//
//  Created by Elchın on 28.09.26.
//


import SwiftUI

struct OnboardingPageView: View {
    let page: OnboardingPage

    private let bottomControlsInset: CGFloat = 170

    var body: some View {
        ZStack {
            Image(page.imageName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
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

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 8) {
                    Text(page.title)
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)

                    Text(page.subtitle)
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.75))
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 28)
            .padding(.bottom, bottomControlsInset)
        }
        
    }
}

#Preview {
    OnboardingPageView(page: OnboardingPage.all[0])
}
