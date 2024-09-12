//
//  RestaurantSearch.swift
//  Feast
//
//  Created by Brent Bumann on 9/3/24.
//

import SwiftUI

struct RestaurantSearch: View {
    @State private var searchText = ""
    let restaurants = ["Italian Bistro", "Sushi Palace", "Burger Town", "Pasta House", "Taco Fiesta", "Pizza Place"]
    
    var filteredRestaurants: [String] {
        if searchText.isEmpty {
            return restaurants
        } else {
            return restaurants.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Restaurants")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Find something to eat...")
        }
        .frame(height: searchText == "" ? 100 : 500)
        .cornerRadius(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 5)
        )
        
    }
}

#Preview {
    RestaurantSearch()
}
