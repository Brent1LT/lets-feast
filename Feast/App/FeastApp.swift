//
//  FeastApp.swift
//  Feast
//
//  Created by Brent Bumann on 9/3/24.
//

import SwiftUI
import Firebase

@main
struct FeastApp: App {
    @StateObject private var locationManager = LocationManager()
    @StateObject var viewModel = AuthViewModel()
    @State private var showSplash = true
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashView()
                } else if viewModel.userSession == nil {
                    LoginView()
                        .environmentObject(viewModel)
                } else {
                    ContentView(locationManager: locationManager)
                        .environmentObject(viewModel)
                }
                
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showSplash = false
                    }
                }
            }
        }
    }
}
