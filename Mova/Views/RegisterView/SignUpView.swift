//
//  SignUpView.swift
//  Mova
//
//  Created by Elchın on 04.09.26.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var authViewModel: AuthViewModel

    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var rememberMe: Bool = false

    var onBack: () -> Void = {}
    var onSignUpSuccess: () -> Void = {}
    var onSignIn: () -> Void = {}

    var body: some View {
        VStack(spacing: 0) {
            BackButton(action: onBack)
            Spacer().frame(height: 24)
            AuthLogo()
            Spacer().frame(height: 20)

            Text("Create Your Account")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)

            Spacer().frame(height: 28)

            VStack(spacing: 14) {
                UsernameField(text: $username)
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
                PrimaryButton(title: "Sign up", action: handleSignUp)
                    .padding(.horizontal, 24)
            }

            Spacer().frame(height: 28)
            OrDivider(text: "or continue with")
                .padding(.horizontal, 24)
            Spacer().frame(height: 20)
            SocialIconsRow(filled: false)
            Spacer()

            Button(action: onSignIn) {
                AuthFooterLink(question: "Already have an account?", actionText: "Sign in")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }

    private func handleSignUp() {
        Task {
            await authViewModel.signUp(email: email, password: password, username: username)
            if authViewModel.userSession != nil {
                onSignUpSuccess()
            }
        }
    }
}

#Preview {
    SignUpView(authViewModel: AuthViewModel())
}
