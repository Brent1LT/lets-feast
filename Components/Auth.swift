//
//  Auth.swift
//  Feast
//
//  Created by Brent Bumann on 10/30/24.
//

import SwiftUI
//import FirebaseAuth

struct AuthView: View {
    @Binding var user: User?
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    
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
                        
//                        TextField("Email", text: $email)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .keyboardType(.emailAddress)
//                            .autocapitalization(.none)
                        
                        InputView(text: $email, title: "Email Address", placeholder: "name@example.com", textColor: .white)
                            
                        
//                        SecureField("Password", text: $password)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true, textColor: .white)
                        
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .fontWeight(.bold)
                                .padding(.top, 5)
                        }
                        
                        Button(action: {
                            // login
                        }) {
                            Text("Log In")
                                .padding()
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            // signup
                        }) {
                            Text("Sign Up")
                                .padding()
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.1)))
                    .padding()
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    AuthView(user: .constant(nil))
}

