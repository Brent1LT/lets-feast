//
//  AuthViewModel.swift
//  Feast
//
//  Created by Brent Bumann on 10/31/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}


@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        if ProcessInfo.processInfo.environment["UITestNewUser"] == "true" { //for UI testing
            signOut()
        } else {
            self.userSession = Auth.auth().currentUser
            Task {
                await fetchUser()
            }
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        print("Sign in...")
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: Failed to login user with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        print("creating user...")
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, email: email, fullName: fullname)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount(withPassword password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            print("DEBUG: No user is logged in")
            return
        }
        
        do {
            try await reauthenticateUser(password: password)
            // If reauthentication succeeds, proceed with deletion
            try await Firestore.firestore().collection("users").document(user.uid).delete()
            try await Auth.auth().currentUser?.delete()
            self.signOut()
        } catch {
            print("DEBUG: Failed to delete account with error \(error.localizedDescription)")
            throw error
        }
    }

    
    // Implement later if issues with deleting accounts and reauthentication is needed
    func reauthenticateUser(password: String) async throws {
        guard let user = Auth.auth().currentUser, let email = user.email else { return }
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        do {
            try await user.reauthenticate(with: credential)
            print("DEBUG: User re-authenticated successfully")
        } catch {
            print("DEBUG: Failed to re-authenticate with error \(error.localizedDescription)")
            throw error
        }
    }


    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
    }
}
