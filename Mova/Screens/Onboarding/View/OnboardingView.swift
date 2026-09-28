//
//  OnboardingView.swift
//  Mova
//
//  Created by Elchın on 03.09.26.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appStateController: AppStateController
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentIndex = 0

    private var isLastPage: Bool {
        currentIndex == OnboardingPage.all.count - 1
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentIndex) {
                ForEach(Array(OnboardingPage.all.enumerated()), id: \.element.id) { index, page in
                    OnboardingPageView(page: page)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()

            bottomControls
        }
    }

    private var bottomControls: some View {
        VStack(spacing: 20) {
            PageIndicator(
                numberOfPages: OnboardingPage.all.count,
                activeIndex: currentIndex
            )
            .animation(.easeInOut(duration: 0.25), value: currentIndex)

            PrimaryButton(
                title: isLastPage ? "Get Started" : "Next",
                hasShadow: true,
                action: handleButtonTap
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }

    private func handleButtonTap() {
        if isLastPage {
            hasSeenOnboarding = true
            appStateController.root = .auth
        } else {
            withAnimation {
                currentIndex += 1
            }
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppStateController())
}
