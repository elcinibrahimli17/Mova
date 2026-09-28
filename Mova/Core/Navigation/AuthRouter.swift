//
//  AuthRouter.swift
//  Mova
//
//  Created by Elchın on 17.09.26.
//


import SwiftUI
import Combine

@MainActor
final class AuthRouter: ObservableObject {
    @Published var path = NavigationPath()

    func push(_ route: AuthRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
}
