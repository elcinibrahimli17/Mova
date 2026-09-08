//
//  ProfileView.swift
//  Mova
//
//  Created by Elchın on 07.09.26.
//


import SwiftUI

struct ProfileView: View {
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text(authViewModel.currentUser?.username ?? "İstifadəçi")
                .font(.title2)
                .fontWeight(.semibold)

            Text(authViewModel.currentUser?.email ?? "")
                .font(.subheadline)
                .foregroundColor(.gray)

            Button(action: authViewModel.signOut) {
                Text("Çıxış et")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.red)
            }
            .padding(.top, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

#Preview {
    ProfileView(authViewModel: AuthViewModel())
}