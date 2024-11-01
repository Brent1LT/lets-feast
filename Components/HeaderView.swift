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
                .frame(width: 50)
            // Title or App Name
            Text("Let's Feast!")
                .font(.headline)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .center)
            
                Image(systemName: isLoggedIn ? "gear" : "person.fill")
                    .foregroundColor(.primary)
                    .font(.system(size: 32))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 5)
                    .frame(width: 50, height: 50)
        }
        .padding(10)
    }
}


#Preview {
    HeaderView()
}

