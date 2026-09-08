//
//  ProfileView.swift
//  Mova
//
//  Created by Elchın on 07.09.26.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var showLogoutConfirmation = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                topBar
                avatarSection
                premiumBanner
                menuList
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
        }
        .background(Color.white)
        .alert("Çıxış et?", isPresented: $showLogoutConfirmation) {
            Button("Ləğv et", role: .cancel) {}
            Button("Çıxış et", role: .destructive) {
                authViewModel.signOut()
            }
        } message: {
            Text("Hesabınızdan çıxmaq istədiyinizə əminsiniz?")
        }
    }

    private var topBar: some View {
        HStack(spacing: 8) {
            Text("M")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.red)

            Text("Profile")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)

            Spacer()
        }
    }

    private var avatarSection: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 100, height: 100)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                    )

                Image(systemName: "pencil")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(6)
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .offset(x: 2, y: 2)
            }

            Text(authViewModel.currentUser?.username ?? "İstifadəçi")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)

            Text(authViewModel.currentUser?.email ?? "")
                .font(.system(size: 13))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }

    private var premiumBanner: some View {
        HStack(spacing: 14) {
            Image(systemName: "crown.fill")
                .font(.system(size: 22))
                .foregroundColor(.red)

            VStack(alignment: .leading, spacing: 4) {
                Text("Join Premium!")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.red)

                Text("Enjoy watching Full-HD movies, without restrictions and without ads")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.red)
        }
        .padding(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.red, lineWidth: 1.5)
        )
    }

    private var menuList: some View {
        VStack(spacing: 4) {
            ProfileMenuRow(icon: "person", title: "Edit Profile")
            ProfileMenuRow(icon: "bell", title: "Notification")
            ProfileMenuRow(icon: "arrow.down.circle", title: "Download")
            ProfileMenuRow(icon: "checkmark.shield", title: "Security")
            ProfileMenuRow(icon: "globe", title: "Language", trailingText: "English (US)")
            ProfileMenuRow(icon: "info.circle", title: "Help Center")

            ProfileMenuRow(
                icon: "rectangle.portrait.and.arrow.right",
                title: "Log Out",
                tintColor: .red,
                action: { showLogoutConfirmation = true }
            )
        }
    }
}

#Preview {
    ProfileView(authViewModel: AuthViewModel())
}
