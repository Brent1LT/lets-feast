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
    @State private var route: MKRoute?
    
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
                        let tag = "\(restaurantLocation.latitude) \(restaurantLocation.longitude)"
                        let display = (route != nil && selectedTag == tag) ?
                            "\(restaurant.name) (\(Int(route!.expectedTravelTime / 60)) mins)" :
                            restaurant.name
                        
                        Marker(display, systemImage: "fork.knife.circle.fill", coordinate: restaurantLocation)
                            .tag(tag)

                    }
                    
                    if let route {
                        MapPolyline(route)
                            .stroke(.blue, lineWidth: 5)
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
                .onChange(of: selectedTag) {
                    getDirections()
                }
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
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
    
    func getDirections() {
        route = nil
        guard let selectedTag else { return }
        guard let userLocation = locationManager.userLocation else { return }
        
        let request = MKDirections.Request()
        let userCoord = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userCoord))
        let destination = selectedTag.split(separator: " ")
        let destinationCoord = CLLocationCoordinate2D(latitude: (destination[0] as NSString).doubleValue, longitude: (destination[1] as NSString).doubleValue)
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoord))
        
        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            route = response?.routes.first
        }

    }
}

#Preview {
    MapView(locationManager: MockLocationManager(mockLocation: CLLocation(latitude: 37.3349, longitude: -122.00902)), width: 300, height: 400, restaurantList: .constant(mockRestaurantList), radius: .constant(20000))
}
