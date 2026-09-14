//
//  MainTabView.swift
//  Mova
//
//  Created by Elchın on 07.09.26.
//


import SwiftUI

struct MainTabView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject private var myListManager = MyListManager()
    @StateObject private var downloadManager = DownloadManager()

    var body: some View {
        TabView {
            HomeView(authViewModel: authViewModel)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "safari")
                }

            MyListView()
                .tabItem {
                    Label("My List", systemImage: "bookmark")
                }

            DownloadView()
                            .tabItem {
                                Label("Download", systemImage: "arrow.down.circle")
                            }

            ProfileView(authViewModel: authViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .tint(.red)
                .environmentObject(myListManager)
                .environmentObject(downloadManager)
    }
}

#Preview {
    MainTabView(authViewModel: AuthViewModel())
}
