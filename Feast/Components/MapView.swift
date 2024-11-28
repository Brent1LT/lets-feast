import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var locationManager: LocationManager
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var route: MKRoute?
    
    var width: CGFloat? // Width passed from parent
    var height: CGFloat? // Height passed from parent
    @Binding var restaurantList: [Restaurant]
    @Binding var radius: Double
    @Binding var selectedID: String?
    
    var body: some View {
        VStack {
            if locationManager.userLocation != nil {
                Map(position: $cameraPosition, selection: $selectedID) {

                    Marker("You", systemImage: "location.circle.fill", coordinate: locationManager.userLocation!.coordinate)
                        .tint(.blue)
                        .tag("you")
                        

                    // Add restaurant markers
                    ForEach(restaurantList) { restaurant in
                        let restaurantLocation = CLLocationCoordinate2D(
                            latitude: restaurant.geometry.location.lat,
                            longitude: restaurant.geometry.location.lng
                        )
                        let tag = "\(restaurant.id)"
                        let display = (route != nil && selectedID == tag) ?
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
                            MapCamera(centerCoordinate: userLocation.coordinate, distance: radius * 5)
                        )
                    }
                }
//                .onChange(of: locationManager.userLocation) {
//                    if locationManager.userLocation != nil {
//                        // Update camera position when the user location changes
//                        cameraPosition = .camera(
//                            MapCamera(centerCoordinate: locationManager.userLocation!.coordinate, distance: radius * 5)
//                        )
//                    }
//                }
                .onChange(of: restaurantList) {
                    if locationManager.userLocation != nil {
                        cameraPosition = .camera(
                            MapCamera(centerCoordinate: locationManager.userLocation!.coordinate, distance: radius * 5)
                        )
                    }
                }
                .onChange(of: selectedID) {
                    getDirections()
                }
                .safeAreaInset(edge: .bottom) {
                    HStack {
                        Spacer()
                        Button {
                            getRandomRestaurant()
                        } label: {
                            Text("Randomize!")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(5)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemBackground))
                                        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 5)
                                )
                        }
                        .disabled(restaurantList.count == 0)
                        .opacity(restaurantList.count > 0 ? 1.0 : 0.5)
                        .accessibilityIdentifier("Randomizer")
                        
                        Spacer()
                    }
                    .padding(10)
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
        if selectedID == "you" { return }
        guard let selectedID else { return }
        guard let userLocation = locationManager.userLocation else { return }
        
        let request = MKDirections.Request()
        let userCoord = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userCoord))
        if let restaurant = restaurantList.first(where: { $0.id == selectedID }) {
            let lat = restaurant.geometry.location.lat
            let long = restaurant.geometry.location.lng
            
            let destinationCoord = CLLocationCoordinate2D(latitude: lat, longitude: long)
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoord))
            
            Task {
                let directions = MKDirections(request: request)
                let response = try? await directions.calculate()
                route = response?.routes.first
            }
            
        } else { return }
    }
    
    func getRandomRestaurant() {
        let random = Int.random(in: 0..<restaurantList.count)
        selectedID = restaurantList[random].id
    }
}

#if DEBUG
// Wrapper View for Preview
struct MapViewWrapper: View {
    @State private var radius = 5000.0
    @State private var selectedID: String? = nil
    
    var body: some View {
        MapView(locationManager: MockLocationManager(mockLocation: CLLocation(latitude: 37.3349, longitude: -122.00902)), width: 300, height: 400, restaurantList: .constant([]), radius: $radius, selectedID: $selectedID)
    }
}

#Preview {
    MapViewWrapper()
}
#endif
