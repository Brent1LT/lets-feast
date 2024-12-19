import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

protocol UserProtocol {
    var uid: String { get }
    var email: String? { get }
}

// Extend `FirebaseAuth.User` to conform to `UserProtocol`
extension FirebaseAuth.User: UserProtocol {}

class MockUser: UserProtocol {
    var uid: String = "mockUserID"
    var email: String? = "mock@user.com"
}



@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: UserProtocol?
    @Published var currentUser: User?
    
    init() {
        if ProcessInfo.processInfo.environment["UITestNewUser"] == "true" { // for UI testing
            signOut()
        } else if ProcessInfo.processInfo.environment["UITestMockUser"] == "true" {
            self.currentUser = User.MOCK_USER
            self.userSession = MockUser()
        } else {
            self.userSession = Auth.auth().currentUser
            Task {
                await fetchUser()
            }
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            AnalyticsManager.shared.logLogIn(params: ["method": "email"])
            self.userSession = result.user
            await fetchUser()
        } catch {
            AnalyticsManager.shared.logEvent(name: "Login_FAILED", params: ["method": "email", "error": "\(error.localizedDescription)"])
            print("DEBUG: Failed to login user with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, email: email, fullName: fullname)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            AnalyticsManager.shared.logSignUp(params: ["method": "email"])
            await fetchUser()
        } catch {
            AnalyticsManager.shared.logEvent(name: "Signup_FAILED", params: ["method": "email", "error": "\(error.localizedDescription)"])
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            AnalyticsManager.shared.logEvent(name: "Signout")
            self.userSession = nil
            self.currentUser = nil
        } catch {
            AnalyticsManager.shared.logEvent(name: "Signout_FAILED", params: ["error": "\(error.localizedDescription)"])
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
            AnalyticsManager.shared.logEvent(name: "DeleteUser")
            AnalyticsManager.shared.removeUserId()
            self.signOut()
        } catch {
            AnalyticsManager.shared.logEvent(name: "DeleteUser_FAILED", params: ["error": "\(error.localizedDescription)"])
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
        guard let uid = Auth.auth().currentUser?.uid else {
            print("DEBUG: No current user ID found.")
            return
        }
        
        do {
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            if snapshot.data() != nil {
                self.currentUser = try? snapshot.data(as: User.self)
                if let currentUser = self.currentUser {
                    print("DEBUG: Successfully decoded user: \(currentUser.fullName)")
                } else {
                    AnalyticsManager.shared.logEvent(name: "FetchedUser_FAILED", params: ["error": "Failed to decode user data"])
                    return
                }
            } else {
                AnalyticsManager.shared.logEvent(name: "FetchedUser_FAILED", params: ["error": "No data found for user document."])
                return
            }
        } catch {
            AnalyticsManager.shared.logEvent(name: "FetchedUser_FAILED", params: ["error": "Error fetching user document: \(error.localizedDescription)"])
            return
        }
        
        AnalyticsManager.shared.setUserId(userId: uid)
        AnalyticsManager.shared.logEvent(name: "FetchedUser")
    }


}
