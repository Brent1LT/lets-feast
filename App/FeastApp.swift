//
//  FeastApp.swift
//  Feast
//
//  Created by Brent Bumann on 9/3/24.
//

import SwiftUI

@main
struct FeastApp: App {
    @StateObject private var locationManager = LocationManager() // Location Manager to track user’s location
    @State private var user: User? = nil
    
    var body: some Scene {
        WindowGroup {
            if user == nil {
                LoginView(user: $user)
            } else {
                ContentView(locationManager: locationManager)
            }
        }
    }
}
