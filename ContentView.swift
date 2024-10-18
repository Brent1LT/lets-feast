//
//  ContentView.swift
//  Feast
//
//  Created by Brent Bumann on 9/3/24.
//

import SwiftUI

struct ContentView: View {
    @State private var restaurantList: [Restaurant] = []
    var location: Location = Location(lng: -122.0089189, lat: 37.3347302)
    
    func getNearbyRestaurants() {
        print("Fetching Restaurants...")
        fetchNearbyRestaurants(keyword: "fastfood", location: location, radius: 1500, maxPrice: 0, minPrice: 0, openNow: true) { result in
            switch result {
            case .success(let restaurants):
                for restaurant in restaurants {
                    print("Restaurant: \(restaurant.name), located at \(restaurant.geometry.location.lat)")
                }
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
            MapView()
                .padding(.vertical, 5)
            RestaurantList(restaurants: $restaurantList)
                .onAppear{
                    getNearbyRestaurants()
                }
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    ContentView()
}
