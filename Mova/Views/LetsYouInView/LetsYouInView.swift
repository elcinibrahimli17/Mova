//
//  LetsYouInView.swift
//  Mova
//
//  Created by Elchın on 04.09.26.
//

import SwiftUI

struct LetsYouInView: View {
    var onBack: () -> Void = {}
    var onSignInWithPassword: () -> Void = {}
    var onSignUp: () -> Void = {}

    var body: some View {
        VStack(spacing: 0) {
            BackButton(action: onBack)

            Spacer().frame(height: 32)

            IllustrationCircle()

            Spacer().frame(height: 28)

            Text("Let's you in")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.black)

            Spacer().frame(height: 28)

            VStack(spacing: 16) {
                SocialLoginButton(icon: "facebook", isSystemIcon: false, title: "Continue with Facebook")
                SocialLoginButton(icon: "google", isSystemIcon: false, title: "Continue with Google")
                SocialLoginButton(icon: "apple.logo", isSystemIcon: true, title: "Continue with Apple")
            }
            .padding(.horizontal, 24)

            OrDivider(text: "or")
                .padding(.horizontal, 24)
                .padding(.top, 24)

            PrimaryButton(title: "Sign in with password", hasShadow: true, action: onSignInWithPassword)
                .padding(.horizontal, 24)
                .padding(.top, 24)

            Spacer()

            Button(action: onSignUp) {
                AuthFooterLink(question: "Don't have an account?", actionText: "Sign up")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

#Preview {
    LetsYouInView()
}
