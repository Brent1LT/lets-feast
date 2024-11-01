//
//  RegistrationView.swift
//  Feast
//
//  Created by Brent Bumann on 10/31/24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?
    @Environment(\.dismiss) var dismiss
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
                        
                        InputView(text: $fullname,
                                  title: "Full Name",
                                  placeholder: "Enter your name",
                                  textColor: .white)
                        
                        InputView(text: $password,
                                  title: "Password",
                                  placeholder: "Enter your password",
                                  isSecureField: true,
                                  textColor: .white)
                            .autocapitalization(.none)
                        
                        InputView(text: $confirmPassword,
                                  title: "Confirm Password",
                                  placeholder: "Confirm your password",
                                  isSecureField: true,
                                  textColor: .white)
                            .autocapitalization(.none)
                        
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .fontWeight(.bold)
                                .padding(.top, 5)
                        }
                        
                        Button {
                            Task {
                                try await viewModel.createUser(withEmail: email, password: password, fullname: fullname)
                            }
                        } label: {
                            HStack {
                                Text("SIGN UP")
                                    .fontWeight(.bold)
                                    
                                Image(systemName: "arrow.right")
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.1)))
                    .padding()
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 3) {
                            Text("Already have an account?")
                            Text("Sign in")
                                .fontWeight(.bold)
                        }
                        .font(.system(size: 18))
                    }

                }
            }
        }
    }
}

#Preview {
    RegistrationView()
}
