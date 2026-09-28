//
//  ContentView.swift
//  Mova
//
//  Created by Elchın on 04.09.26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var appState = AppStateController()
    @AppStorage("appLanguage") private var appLanguageRaw: String = AppLanguage.english.rawValue
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        contentView
            .environment(\.locale, AppLanguage(rawValue: appLanguageRaw)?.locale ?? Locale(identifier: "en"))
            .environmentObject(authViewModel)
            .environmentObject(appState)
            .onAppear {
                checkSessionAndNavigate()
            }
            .onChange(of: authViewModel.userSession == nil) {
                _, isLoggedOut in
                if isLoggedOut && appState.root == .tabbar {
                    appState.root = .auth
                }
            }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch appState.root {
        case .launch:
            SplashView()
            
        case .onBoarding:
            OnboardingView()
            
        case .auth:
            AuthFlowView()
            
        case .tabbar:
            MainTabView()
        }
    }
    
    private func checkSessionAndNavigate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if !hasSeenOnboarding {
                appState.root = .onBoarding
            } else if authViewModel.isLoggedIn {
                Task {
                    await authViewModel.fetchUser()
                    appState.root = .tabbar
                }
            } else {
                appState.root = .auth
            }
        }
    }
    
}

#Preview {
    ContentView()
}
