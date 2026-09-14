//
//  ContentView.swift
//  Mova
//
//  Created by Elchın on 04.09.26.
//


import SwiftUI

enum AppScreen {
    case splash
    case onboarding
    case letsYouIn
    case signUp
    case login
    case home
}

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var currentScreen: AppScreen = .splash

    var body: some View {
        Group {
            switch currentScreen {
            case .splash:
                SplashView()

            case .onboarding:
                OnboardingView {
                    currentScreen = .letsYouIn
                }

            case .letsYouIn:
                LetsYouInView(
                    onBack: { currentScreen = .onboarding },
                    onSignInWithPassword: { currentScreen = .login },
                    onSignUp: { currentScreen = .signUp }
                )

            case .signUp:
                SignUpView(
                    authViewModel: authViewModel,
                    onBack: { currentScreen = .letsYouIn },
                    onSignUpSuccess: { currentScreen = .home },
                    onSignIn: { currentScreen = .login }
                )

            case .login:
                LoginView(
                    authViewModel: authViewModel,
                    onBack: { currentScreen = .letsYouIn },
                    onSignInSuccess: { currentScreen = .home },
                    onForgotPassword: {},
                    onSignUp: { currentScreen = .signUp }
                )

            case .home:
                MainTabView(authViewModel: authViewModel)
            }
        }
        .onAppear {
            checkSessionAndNavigate()
        }
        .onChange(of: authViewModel.userSession == nil) { _, isLoggedOut in
            if isLoggedOut && currentScreen == .home {
                withAnimation {
                    currentScreen = .login
                }
            }
        }
    }

    private func checkSessionAndNavigate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if authViewModel.isLoggedIn {
                Task {
                    await authViewModel.fetchUser()
                    withAnimation {
                        currentScreen = .home
                    }
                }
            } else {
                withAnimation {
                    currentScreen = .onboarding
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
