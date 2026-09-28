//
//  AuthFlowView.swift
//  Mova
//
//  Created by Elchın on 17.09.26.
//

import SwiftUI

struct AuthFlowView: View {
    @StateObject private var router = AuthRouter()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            LetsYouInView()
                .navigationDestination(for: AuthRoute.self) { route in
                    destination(for: route)
                }
        }
        .environmentObject(router)
    }
    
    @ViewBuilder
    private func destination(for route: AuthRoute) -> some View {
        switch route {
        case .signUp:
            SignUpView()
            
        case .login:
            LoginView()
        }
    }
}

