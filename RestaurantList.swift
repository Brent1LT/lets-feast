//
//  RestaurantList.swift
//  Feast
//
//  Created by Brent Bumann on 9/11/24.
//

import SwiftUI

struct RestaurantList: View {
    var restaurants: [Restaurant] = []
    
    var body: some View {
        ScrollView {
            ForEach(restaurants) { restaurant in
                HStack {
                    AsyncImage(url: URL(string: restaurant.thumbnail), content: { image in
                            image
                            .resizable(capInsets: EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        }, placeholder: {
                            ProgressView()
                        }
                    )
                    Text(restaurant.name)
                }
            }
        }
        .padding()
    }
}

#Preview {
    RestaurantList(restaurants: mockRestaurantList)
}
