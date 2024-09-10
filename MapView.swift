//
//  MapView.swift
//  Feast
//
//  Created by Brent Bumann on 9/6/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var locationManager = LocationManager() // Location Manager to track user’s location
    @State private var cameraPosition: MapCameraPosition = .automatic // Use automatic camera position initially
    var width: CGFloat? // Width passed from parent
    var height: CGFloat? // Height passed from parent
    
    var body: some View {
        VStack {
            if locationManager.userLocation != nil {
                Map(position: $cameraPosition) {
                    // Empty content block because the map will automatically show the user's location
                }
                .onAppear {
                    // Set camera to follow user location with a fallback if location is not available
                    cameraPosition = .userLocation(followsHeading: false, fallback: .automatic)
                }
                .frame(width: width, height: height)
                .cornerRadius(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 5)
                )
            } else {
                // Show a placeholder while waiting for the user's location
                Text("Getting your location...")
                    .frame(width: width, height: height)
            }
        }
        .onAppear {
            locationManager.requestLocation() // Request location when the view appears
        }
    }
}

#Preview {
    MapView(width: 300, height: 400)
}
