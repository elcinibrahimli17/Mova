//
//  LoginView.swift
//  Mova
//
//  Created by Elchın on 04.09.26.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var authViewModel: AuthViewModel

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var rememberMe: Bool = false

    var onBack: () -> Void = {}
    var onSignInSuccess: () -> Void = {}
    var onForgotPassword: () -> Void = {}
    var onSignUp: () -> Void = {}

    var body: some View {
        VStack(spacing: 0) {
            BackButton(action: onBack)
            Spacer().frame(height: 24)
            AuthLogo()
            Spacer().frame(height: 20)

            Text("Login to Your Account")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)

            Spacer().frame(height: 28)

            VStack(spacing: 14) {
                EmailField(text: $email)
                PasswordField(text: $password, isVisible: $isPasswordVisible)
            }
            .padding(.horizontal, 24)

            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .font(.system(size: 13))
                    .foregroundColor(.red)
                    .padding(.top, 8)
                    .padding(.horizontal, 24)
                    .multilineTextAlignment(.center)
            }

            Spacer().frame(height: 16)
            RememberMeToggle(isOn: $rememberMe)
            Spacer().frame(height: 20)

            if authViewModel.isLoading {
                ProgressView()
                    .padding(.horizontal, 24)
            } else {
                PrimaryButton(title: "Sign in", action: handleSignIn)
                    .padding(.horizontal, 24)
            }

            Spacer().frame(height: 16)

            Button(action: onForgotPassword) {
                Text("Forgot the password?")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.red)
            }

            Spacer().frame(height: 24)
            OrDivider(text: "or continue with")
                .padding(.horizontal, 24)
            Spacer().frame(height: 20)
            SocialIconsRow(filled: true)
            Spacer()

            Button(action: onSignUp) {
                AuthFooterLink(question: "Don't have an account?", actionText: "Sign up")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }

    private func handleSignIn() {
        Task {
            await authViewModel.login(email: email, password: password)
            if authViewModel.userSession != nil {
                onSignInSuccess()
            }
        }
    }
}

#Preview {
    LoginView(authViewModel: AuthViewModel())
}
