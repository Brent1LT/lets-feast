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
    
    var body: some Scene {
        WindowGroup {
            ContentView(locationManager: locationManager)
        }
    }
}
