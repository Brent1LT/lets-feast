import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showPasswordPrompt = false
    @State private var password = ""
    @State private var errorMessage: String?
    
    var body: some View {
        if let user = viewModel.currentUser {
            List {
                Section {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.fullName)
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.top, 4)
                            
                            Text(user.email)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    
                }
                
                Section("General") {
                    HStack {
                        SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
                        
                        Spacer()
                        
                        Text(AppConfig.appVersion)
                            .font(.subheadline)
                            .foregroundColor(Color(.systemGray))
                    }
                }
                
                Section("Account") {
                    Button {
                        viewModel.signOut()
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                    }
                    .accessibilityIdentifier("Sign out")
                    
                    Button {
                        showPasswordPrompt = true
                    }label: {
                        SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: .red)
                    }
                    .accessibilityIdentifier("Delete account")
                    .alert("Re-enter Password", isPresented: $showPasswordPrompt) {
                        SecureField("Password", text: $password)
                        
                        Button("Cancel", role: .cancel) {
                            password = ""
                        }
                        
                        Button("Confirm") {
                            Task {
                                do {
                                    try await viewModel.deleteAccount(withPassword: password)
                                    password = ""
                                } catch {
                                    errorMessage = error.localizedDescription
                                    showPasswordPrompt = true
                                }
                            }
                        }
                    } message: {
                        if let errorMessage = errorMessage {
                            Text(errorMessage).foregroundColor(.red)
                        } else {
                            Text("Please re-enter your password to confirm account deletion.")
                        }
                    }
                }
            }
            .analyticsScreen(name: "ProfileView")
        }
    }
}

#Preview {
    let authViewModel = AuthViewModel()
    authViewModel.currentUser = User.MOCK_USER // Set the mock user here
    
    return ProfileView()
        .environmentObject(authViewModel)
}
