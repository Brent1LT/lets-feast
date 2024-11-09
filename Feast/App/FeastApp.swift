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
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if viewModel.userSession == nil {
                LoginView()
                    .environmentObject(viewModel)
            } else {
                ContentView(locationManager: locationManager)
                    .environmentObject(viewModel)
            }
        }
    }
}
