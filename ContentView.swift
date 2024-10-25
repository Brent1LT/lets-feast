//
//  ContentView.swift
//  Feast
//
//  Created by Brent Bumann on 9/3/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var locationManager: LocationManager
    @State private var restaurantList: [Restaurant] = []
    @State private var radius: Double = 20000
    
    
    func getNearbyRestaurants() {
        print("Fetching Restaurants...")
//        print("\(locationManager.userLocation)")
        guard let lat = locationManager.userLocation?.coordinate.latitude,
              let long = locationManager.userLocation?.coordinate.longitude
        else {
            print("User location is not available. Cannot fetch nearby restaurants.")
            return
        }
        
        let location: Location = Location(lng: long, lat: lat)
        fetchNearbyRestaurants(keyword: "fancy food", location: location, radius: 1500, maxPrice: 0, minPrice: 0, openNow: true) { result in
            switch result {
            case .success(let restaurants):
                restaurantList = restaurants
            case .failure(let error):
                print("Error fetching nearby restaurants: \(error.localizedDescription)")
                
            }
        }
    }
    
    var body: some View {
        VStack {
            HeaderView()
            FiltersView()
            RestaurantSearch()
            MapView(locationManager: locationManager, restaurantList: $restaurantList, radius: $radius)
                .padding(.vertical, 5)
            RestaurantList(restaurants: $restaurantList)
        }
        .padding(.horizontal, 10)
        .onAppear {
            locationManager.requestLocation()
            getNearbyRestaurants()
        }
        .onChange(of: locationManager.userLocation) {
            // Trigger fetching restaurants only after location is available
            if(restaurantList.count == 0) { getNearbyRestaurants() }
        }
    }
}

#Preview {
    ContentView(locationManager: MockLocationManager())
}
