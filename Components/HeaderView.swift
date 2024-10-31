//
//  HeaderView.swift
//  Feast
//
//  Created by Brent Bumann on 9/3/24.
//

import SwiftUI

struct HeaderView: View {
    @State private var isLoggedIn: Bool = false // Assume this state is managed elsewhere
    @State private var profileImage: Image? = nil // Replace with a real image if logged in
    
    var body: some View {
        HStack {
            Spacer()
            // Title or App Name
            Text("Let's Feast!")
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.leading, 10)
            
            Spacer()
            
            // Optionally, you could add a logout/login button or settings icon
            Button(action: {
                // Action for login/logout or settings
            }) {
                Image(systemName: isLoggedIn ? "gear" : "person.fill")
                    .foregroundColor(.primary)
                    .font(.system(size: 32))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 5)
            }
        }
        .padding(5.0)
    }
}


#Preview {
    HeaderView()
}
