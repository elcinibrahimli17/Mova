//
//  OnboardingPage.swift
//  Mova
//
//  Created by Elchın on 28.09.26.
//


import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let imageName: String
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
}

extension OnboardingPage {
    static let all: [OnboardingPage] = [
        OnboardingPage(
            imageName: "splashmovie",
            title: "Welcome to Mova",
            subtitle: "The best movie streaming app of the century\nto make your days great!"
        ),
        OnboardingPage(
            imageName: "onboarding2",
            title: "Discover Movies",
            subtitle: "Explore trending, popular and top rated\nmovies from all around the world."
        ),
        OnboardingPage(
            imageName: "onboarding3",
            title: "Watch Anywhere",
            subtitle: "Save your favorites, download movies\nand enjoy them anytime, anywhere."
        )
    ]
}