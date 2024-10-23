//
//  mockLocationManager.swift
//  Feast
//
//  Created by Brent Bumann on 10/23/24.
//

import Foundation
import CoreLocation

class MockLocationManager: LocationManager {
    override init() {
        super.init()
        // Set a predefined location
        self.userLocation = CLLocation(latitude: 37.3347302, longitude: -122.0089189)
    }
}
