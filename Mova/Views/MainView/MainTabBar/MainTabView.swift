//
//  MainTabView.swift
//  Mova
//
//  Created by Elchın on 07.09.26.
//


import SwiftUI

struct MainTabView: View {
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        TabView {
            HomeView(authViewModel: authViewModel)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            Text("Explore")
                .tabItem {
                    Label("Explore", systemImage: "safari")
                }

            Text("My List")
                .tabItem {
                    Label("My List", systemImage: "bookmark")
                }

            Text("Download")
                .tabItem {
                    Label("Download", systemImage: "arrow.down.circle")
                }

            ProfileView(authViewModel: authViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .tint(.red)
    }
}

#Preview {
    MainTabView(authViewModel: AuthViewModel())
}