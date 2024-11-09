import Foundation
import CoreLocation

// Custom LocationManager class for handling location services
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    @Published var userLocation: CLLocation?
    @Published var isLocationPermissionDenied: Bool = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkInitialAuthorizationStatus()
    }
    
    // Request location permission and start updating the location
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func checkInitialAuthorizationStatus() {
        let status = locationManager.authorizationStatus
        print("Location Manager Permission: \(status)")
        isLocationPermissionDenied = (status == .denied || status == .restricted)
        print("Permission: \(isLocationPermissionDenied)")
    }
    
    // CLLocationManagerDelegate method to update the user's location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            DispatchQueue.main.async {
                self.userLocation = location // Update the user location
            }
        } else {
            print("No locations available")
        }
    }
    
    // Handle location authorization status changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        DispatchQueue.main.async {
            self.isLocationPermissionDenied = (status == .denied || status == .restricted)
        }
    }

    // Handle location update errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error.localizedDescription)")
    }
}
