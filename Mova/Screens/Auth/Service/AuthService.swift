//
//  AuthService.swift
//  Mova
//
//  Created by Elchın on 07.09.26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum AuthServiceError: LocalizedError {
    case userNotFound
    case emptyUsername

    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "İstifadəçi məlumatı tapılmadı."
        case .emptyUsername:
            return "Zəhmət olmasa istifadəçi adını daxil edin."
        }
    }
}

class AuthService {

    private let db = Firestore.firestore()

    func login(withEmail email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }

    func createUser(email: String, password: String, username: String) async throws {
        guard !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AuthServiceError.emptyUsername
        }

        let result = try await Auth.auth().createUser(withEmail: email, password: password)

        let newUser = User(
            id: result.user.uid,
            username: username,
            email: email,
            createdAt: Date()
        )

        try db.collection("users").document(newUser.id).setData(from: newUser)
    }

    func loadUserData() async throws -> User {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AuthServiceError.userNotFound
        }

        let snapshot = try await db.collection("users").document(uid).getDocument()

        guard let user = try? snapshot.data(as: User.self) else {
            throw AuthServiceError.userNotFound
        }

        return user
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }
}
