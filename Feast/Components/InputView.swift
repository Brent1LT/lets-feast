//
//  InputView.swift
//  Feast
//
//  Created by Brent Bumann on 10/30/24.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField: Bool = false
    let textColor: Color
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(textColor)
                .fontWeight(.semibold)
                .font(.footnote)
            
            if isSecureField {
                SecureField("", text: $text, prompt: Text(placeholder).foregroundColor(Color(.darkGray)))
                    .textContentType(.newPassword)
                    .autocorrectionDisabled(true)
                    .font(.system(size: 18))
            } else {
                TextField("", text: $text, prompt: Text(placeholder).foregroundColor(Color(.darkGray)))
                    .foregroundColor(textColor)
                    .font(.system(size: 18))
            }
            
            Divider()
                .overlay(textColor)
        }
    }
}

#Preview {
    InputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com", textColor: .black)
}
