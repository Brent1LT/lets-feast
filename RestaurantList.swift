//
//  RestaurantList.swift
//  Feast
//
//  Created by Brent Bumann on 9/11/24.
//

import SwiftUI

struct RestaurantList: View {
    @Binding var restaurants: [Restaurant]
    
    var body: some View {
        VStack {
            if restaurants.isEmpty {
                VStack {
                    ProgressView()
                    Text("Searching for nearby restaurants...")
                        .font(.headline)
                        .padding(.top, 10)
                }
                .padding()
            } else {
                ScrollView {
                    ForEach(restaurants) { restaurant in
                        HStack(alignment: .top) {
                            AsyncImage(url: URL(string: restaurant.thumbnailURL ?? ""), content: { image in
                                image
                                    .resizable()
                                    .frame(height: 150)
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            }, placeholder: {
                                ProgressView()
                            }
                            )
                            .padding(.trailing, 10)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(restaurant.name)
                                    .font(.headline)
                                
                                
                                Text(restaurant.vicinity)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text(restaurant.rating != nil ? "Rating: \(restaurant.rating!, specifier: "%.1f")" : "Rating: Unknown")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 8)
                        }
                        .padding(.trailing, 10.0)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemBackground))
                        )
                    }
                }
            }
            
        }
    }
}

var restaurants: [Restaurant] = mockRestaurantList
var empty: [Restaurant] = []
#Preview {
    RestaurantList(restaurants: .constant(restaurants))
}
