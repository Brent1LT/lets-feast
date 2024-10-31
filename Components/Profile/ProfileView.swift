//
//  ProfileView.swift
//  Feast
//
//  Created by Brent Bumann on 10/31/24.
//

import SwiftUI

struct ProfileView: View {
    @Binding var user: User
    
    var body: some View {
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
                    
                    Text("1.0.0")
                        .font(.subheadline)
                        .foregroundColor(Color(.systemGray))
                }
            }
            
            Section("Account") {
                Button {
                    // Sign Out
                } label: {
                    SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                }
                
                Button {
                    // Delete Account
                }label: {
                    SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: .red)
                }
            }
        }
    }
}

#Preview {
    ProfileView(user: .constant(User.MOCK_USER))
}