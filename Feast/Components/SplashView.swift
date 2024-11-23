//
//  SplashView.swift
//  Feast
//
//  Created by Brent Bumann on 11/22/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                Text("Let's Feast!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
                
        }
    }
}

#Preview {
    SplashView()
}
