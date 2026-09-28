//
//  AppStateController.swift
//  Mova
//
//  Created by Elchın on 17.09.26.
//

import SwiftUI
import Combine

@MainActor
final class AppStateController: ObservableObject {
    @Published var root: AppRoot = .launch
    @Published var selectedTab: AppTab = .home
    @Published var shouldFocusSearch = false
}

