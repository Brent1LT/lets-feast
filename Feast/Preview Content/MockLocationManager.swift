//
//  mockLocationManager.swift
//  Feast
//
//  Created by Brent Bumann on 10/23/24.
//

import Foundation
import CoreLocation

class MockLocationManager: LocationManager {
    // Modify the initializer to accept an optional location
    init(mockLocation: CLLocation? = nil) {
        super.init()
        // If mockLocation is provided, use it; otherwise, use the predefined location
        self.userLocation = mockLocation ?? CLLocation(latitude: 37.688373, longitude: -121.053543)
    }
    
    override func requestLocation() {
        return
    }
}

