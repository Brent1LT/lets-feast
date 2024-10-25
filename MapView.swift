//
//  MapView.swift
//  Feast
//
//  Created by Brent Bumann on 9/6/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var locationManager: LocationManager
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var selectedTag: String?
    
    var width: CGFloat? // Width passed from parent
    var height: CGFloat? // Height passed from parent
    @Binding var restaurantList: [Restaurant]
    @Binding var radius: Double
    
    var body: some View {
        VStack {
            if locationManager.userLocation != nil {
                Map(position: $cameraPosition, selection: $selectedTag) {

                    Marker("You", systemImage: "location.circle.fill", coordinate: locationManager.userLocation!.coordinate)
                        .tint(.blue)
                        .tag("you")
                        

                    // Add restaurant markers
                    ForEach(restaurantList) { restaurant in
                        let restaurantLocation = CLLocationCoordinate2D(
                            latitude: restaurant.geometry.location.lat,
                            longitude: restaurant.geometry.location.lng
                        )
                        
                        Marker(restaurant.name, systemImage: "fork.knife.circle.fill", coordinate: restaurantLocation)
                            .tag(restaurant.id)
                    }
                }
                .onAppear {
                    if let userLocation = locationManager.userLocation {
                        cameraPosition = .camera(
                            MapCamera(centerCoordinate: userLocation.coordinate, distance: radius)
                        )
                    }
                }
                .onChange(of: locationManager.userLocation) {
                    if locationManager.userLocation != nil {
                        // Update camera position when the user location changes
                        cameraPosition = .camera(
                            MapCamera(centerCoordinate: locationManager.userLocation!.coordinate, distance: radius)
                        )
                    }
                }
                .onChange(of: restaurantList) {
                    if locationManager.userLocation != nil {
                        cameraPosition = .camera(
                            MapCamera(centerCoordinate: locationManager.userLocation!.coordinate, distance: radius)
                        )
                    }
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
    }
}

#Preview {
    MapView(locationManager: MockLocationManager(mockLocation: CLLocation(latitude: 37.3349, longitude: -122.00902)), width: 300, height: 400, restaurantList: .constant(mockRestaurantList), radius: .constant(20000))
}
