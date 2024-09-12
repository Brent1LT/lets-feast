//
//  ContentView.swift
//  Feast
//
//  Created by Brent Bumann on 9/3/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            HeaderView()
            FiltersView()
            RestaurantSearch()
            MapView()
                .padding(.vertical, 5)
            RestaurantList(restaurants: mockRestaurantList)
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    ContentView()
}
