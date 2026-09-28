//
//  LoginView.swift
//  Mova
//
//  Created by Elchın on 04.09.26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: AuthRouter
    @EnvironmentObject var appStateController: AppStateController

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var rememberMe: Bool = false

    var onForgotPassword: () -> Void = {}

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

            Spacer().frame(height: 16)
            forgotPasswordButton
            Spacer().frame(height: 24)

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

            Text("Login to Your Account")
                .authTitleStyle()
        }
    }

    private var formFields: some View {
        VStack(spacing: 14) {
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
            PrimaryButton(title: "Sign in", action: handleSignIn)
                .padding(.horizontal, 24)
        }
    }

    private var forgotPasswordButton: some View {
        Button(action: onForgotPassword) {
            Text("Forgot the password?")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.red)
        }
    }

    private var socialSection: some View {
        VStack(spacing: 20) {
            OrDivider(text: "or continue with")
                .padding(.horizontal, 24)

            SocialIconsRow(filled: true)
        }
    }

    private var footer: some View {
        Button {
            router.push(.signUp)
        } label: {
            AuthFooterLink(question: "Don't have an account?", actionText: "Sign up")
        }
    }

    private func handleSignIn() {
        Task {
            await authViewModel.login(email: email, password: password)
            if authViewModel.userSession != nil {
                    appStateController.root = .tabbar
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
        .environmentObject(AuthRouter())
}
