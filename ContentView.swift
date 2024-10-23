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
    
    
    func getNearbyRestaurants() {
        print("Fetching Restaurants...")
        guard var lat = locationManager.userLocation?.coordinate.latitude,
              let long = locationManager.userLocation?.coordinate.longitude
        else {
            print("User location is not available. Cannot fetch nearby restaurants.")
            return
        }
        
        var location: Location = Location(lng: long, lat: lat)
        print(location)
        fetchNearbyRestaurants(keyword: "fastfood", location: location, radius: 1500, maxPrice: 0, minPrice: 0, openNow: true) { result in
            switch result {
            case .success(let restaurants):
//                for restaurant in restaurants {
//                    print("Restaurant: \(restaurant.name), located at \(restaurant.geometry.location.lat)")
//                }
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
            MapView(locationManager: locationManager)
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

private var locationManager = MockLocationManager()
#Preview {
    ContentView(locationManager: locationManager)
}
