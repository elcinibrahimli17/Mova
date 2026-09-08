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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
    
    private var header: some View {
        VStack(spacing: 20) {
            AuthLogo()
            
            Text("Login to Your Account")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
        }
    }
    
    private var formFields: some View {
        VStack(spacing: 14) {
            EmailField(text: $email)
            PasswordField(text: $password, isVisible: $isPasswordVisible)
            
            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .font(.system(size: 13))
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
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
        Button(action: onSignUp) {
            AuthFooterLink(question: "Don't have an account?", actionText: "Sign up")
        }
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
