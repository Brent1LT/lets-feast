import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color.black
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .foregroundStyle(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: geometry.size.width * 1.5, height: geometry.size.height * 2)
                        .rotationEffect(.degrees(55))
                        .offset(x: -geometry.size.width * 0.9, y: -geometry.size.height * 0.7)
                }
                .ignoresSafeArea()
                
                
                VStack {
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Text("Let's Feast!")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .bold()
                            .padding(.bottom, 30)
                                                
                        InputView(text: $email, 
                                  title: "Email Address",
                                  placeholder: "name@example.com",
                                  textColor: .white)
                            .autocapitalization(.none)
                            .accessibilityIdentifier("Email Address")
                            
                        
                        InputView(text: $password, 
                                  title: "Password",
                                  placeholder: "Enter your password",
                                  isSecureField: true,
                                  textColor: .white)
                            .autocapitalization(.none)
                            .accessibilityIdentifier("Password")
                        
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .fontWeight(.bold)
                                .padding(.top, 5)
                        }
                        
                        Button {
                            Task {
                                do {
                                    try await viewModel.signIn(withEmail: email, password: password)
                                } catch {
                                    errorMessage = error.localizedDescription
                                }
                            }
                        } label: {
                            HStack {
                                Text("SIGN IN")
                                    .fontWeight(.bold)
                                    
                                Image(systemName: "arrow.right")
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                            
                        }
                        .disabled(!formIsValid)
                        .opacity(formIsValid ? 1.0 : 0.5)
                        .padding(.top, 10)
                        .accessibilityIdentifier("Sign in button")
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.1)))
                    .padding()
                    
                    Spacer()
                    
                    NavigationLink {
                        RegistrationView()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        HStack(spacing: 3) {
                            Text("Don't have an account?")
                            Text("Sign up")
                                .fontWeight(.bold)
                        }
                        .font(.system(size: 18))
                    }

                }
            }
        }
    }
}

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty &&
        email.contains("@") &&
        !password.isEmpty &&
        password.count > 5
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}

