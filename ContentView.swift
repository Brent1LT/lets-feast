//
//  ContentView.swift
//  Feast
//
//  Created by Brent Bumann on 9/3/24.
//

import SwiftUI

struct ContentView: View {
    @State private var restaurantList: [Restaurant] = []
    
    var body: some View {
        VStack {
            HeaderView()
            FiltersView()
            RestaurantSearch()
            MapView()
                .padding(.vertical, 5)
            RestaurantList(restaurants: restaurantList)
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    ContentView()
}
