import SwiftUI
import MapKit

struct RestaurantList: View {
    @Binding var restaurants: [Restaurant]
    @Binding var selectedID: String?
    
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
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(restaurants) { restaurant in
                                RestaurantItem(restaurant: restaurant)
                                .padding(.trailing, 10.0)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemBackground))
                                )
                                .frame(maxWidth: .infinity)
                                .id(restaurant.id) // Set a unique ID for each restaurant
                                .onTapGesture {
                                    selectedID = restaurant.id
                                }

                            }
                        }
                    }
                    .onChange(of: selectedID) {
                        withAnimation {
                            proxy.scrollTo(selectedID, anchor: .center)
                        }
                    }
                    .accessibilityIdentifier("Restaurant List")
                }
            }
            
        }
    }
}

#if DEBUG
var restaurants: [Restaurant] = mockRestaurantList
var empty: [Restaurant] = []
#Preview {
    RestaurantList(restaurants: .constant(restaurants), selectedID: .constant(nil))
}
#endif
