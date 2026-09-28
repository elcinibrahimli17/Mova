//
//  MainTabView.swift
//  Mova
//
//  Created by Elchın on 07.09.26.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppStateController

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(AppTab.home)

            ExploreView()
                .tabItem { Label("Explore", systemImage: "safari") }
                .tag(AppTab.explore)

            MyListView()
                .tabItem { Label("My List", systemImage: "bookmark") }
                .tag(AppTab.myList)

            DownloadView()
                .tabItem { Label("Download", systemImage: "arrow.down.circle") }
                .tag(AppTab.download)

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person") }
                .tag(AppTab.profile)
        }
        .tint(.red)
    }
}
