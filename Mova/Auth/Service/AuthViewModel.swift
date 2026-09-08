//
//  AuthViewModel.swift
//  Mova
//
//  Created by Elchın on 07.09.26.
//


import Foundation
import Combine
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {

    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    private let authService = AuthService()

    init() {
        self.userSession = Auth.auth().currentUser
    }

    var isLoggedIn: Bool {
        userSession != nil
    }

    func login(email: String, password: String) async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            try await authService.login(withEmail: email, password: password)
            self.userSession = Auth.auth().currentUser
            await fetchUser()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signUp(email: String, password: String, username: String) async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            try await authService.createUser(email: email, password: password, username: username)
            self.userSession = Auth.auth().currentUser
            await fetchUser()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func fetchUser() async {
        do {
            self.currentUser = try await authService.loadUserData()
        } catch {
            self.currentUser = nil
        }
    }

    func signOut() {
        do {
            try authService.signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
