//
//  SignUpView.swift
//  Mova
//
//  Created by Elchın on 04.09.26.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: AuthRouter
    @EnvironmentObject var appStateController: AppStateController

    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var rememberMe: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            BackButton(action: { router.pop() })
            Spacer().frame(height: 24)

            header

            Spacer().frame(height: 28)

            formFields

            Spacer().frame(height: 16)
            RememberMeToggle(isOn: $rememberMe)
            Spacer().frame(height: 20)

            submitButton

            Spacer().frame(height: 28)
            socialSection

            Spacer()
            footer
        }
        .authScreenBackground()
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        VStack(spacing: 20) {
            AuthLogo()
            Text("Create Your Account")
                .authTitleStyle()
        }
    }

    private var formFields: some View {
        VStack(spacing: 14) {
            UsernameField(text: $username)
            EmailField(text: $email)
            PasswordField(text: $password, isVisible: $isPasswordVisible)

            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .errorTextStyle()
            }
        }
        .padding(.horizontal, 24)
    }

    @ViewBuilder
    private var submitButton: some View {
        if authViewModel.isLoading {
            ProgressView()
                .padding(.horizontal, 24)
        } else {
            PrimaryButton(title: "Sign up", action: handleSignUp)
                .padding(.horizontal, 24)
        }
    }

    private var socialSection: some View {
        VStack(spacing: 20) {
            OrDivider(text: "or continue with")
                .padding(.horizontal, 24)

            SocialIconsRow(filled: false)
        }
    }

    private var footer: some View {
        Button {
            router.push(.login)
        } label: {
            AuthFooterLink(question: "Already have an account?", actionText: "Sign in")
        }
    }

    private func handleSignUp() {
        Task {
            await authViewModel.signUp(email: email, password: password, username: username)
            if authViewModel.userSession != nil {
                appStateController.root = .tabbar
            }
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthViewModel())
        .environmentObject(AuthRouter())
}
