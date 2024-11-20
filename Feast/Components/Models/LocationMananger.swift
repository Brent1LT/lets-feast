import Foundation
import CoreLocation

// Custom LocationManager class for handling location services
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published var userLocation: CLLocation?
    @Published var isLocationPermissionDenied: Bool = false
    @Published var generalizedLocation: String = "Unknown Location"
    
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
        isLocationPermissionDenied = (status == .denied || status == .restricted)
    }
    
    // CLLocationManagerDelegate method to update the user's location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            DispatchQueue.main.async {
                self.userLocation = location // Update the user location
                self.updateGeneralizedLocation(for: location)
            }
        } else {
            print("No locations available")
        }
    }
    
    private func updateGeneralizedLocation(for location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            if let placemark = placemarks?.first {
                let city = placemark.locality ?? "Unknown City"
                let country = placemark.country ?? "Unknown Country"
                DispatchQueue.main.async {
                    self.generalizedLocation = "\(city), \(country)"
                }
            } else {
                DispatchQueue.main.async {
                    self.generalizedLocation = "Unknown Location"
                }
            }
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
        AnalyticsManager.shared.logEvent(name: "Location_FAILED", params: ["error": "\(error.localizedDescription)"])
    }
}
