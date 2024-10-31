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
                                HStack(alignment: .top) {
                                    AsyncImage(url: URL(string: restaurant.thumbnailURL ?? ""), content: { image in
                                        image
                                            .resizable()
                                            .frame(width: 200, height: 150)
                                            .scaledToFit()
                                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    }, placeholder: {
                                        ProgressView()
                                            .frame(width: 200, height: 150)
                                            .background(Color(.systemGray6))
                                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    }
                                    )
                                    .padding(.trailing, 10)
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(restaurant.name)
                                            .font(.headline)
                                            .lineLimit(2)
                                            .truncationMode(.tail)
                                        
                                        
                                        Text(restaurant.vicinity)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                        
                                        HStack(alignment: .bottom, spacing: 3.0) {
                                            Text(restaurant.rating != nil ? "Rating: \(restaurant.rating!, specifier: "%.1f")" : "Rating: Unknown")
                                                .font(.subheadline)
                                                .fontWeight(.bold)
                                                .foregroundColor(.accentColor)
                                                .lineLimit(1)
                                            .truncationMode(.tail)
                                            
                                            if restaurant.rating != nil {
                                                Image(systemName: "star.fill")
                                                    .font(.subheadline)
                                                    .foregroundColor(.yellow)
                                            }
                                        }

                                        Button {
                                            let lat = restaurant.geometry.location.lat
                                            let long = restaurant.geometry.location.lng
                                            
                                            let coord = CLLocationCoordinate2D(latitude: lat, longitude: long)
                                            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coord))
                                            mapItem.name = restaurant.name
                                            print("Opening in Maps directions to \(restaurant.name)")
                                            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
                                        } label: {
                                            Text("Open in Apple Maps")
                                                .font(.caption)
                                                .fontWeight(.bold)
                                        }
                                        .padding(.top, 5)
                                        
                                        if restaurant.priceLevel != nil {
                                            Spacer()
                                            Text("Price")
                                                .font(.subheadline)
                                            HStack(spacing: 3) {
                                                ForEach(1...restaurant.priceLevel!, id: \.self) { number in
                                                    Image(systemName: "dollarsign.circle")
                                                        .foregroundColor(.green)
                                                        .font(.caption)
                                                }
                                            }
                                        }
                                    }
                                    .padding(.vertical, 8)
                                }
                                .padding(.trailing, 10.0)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemBackground))
                                )
                                .id(restaurant.id) // Set a unique ID for each restaurant
                            }
                        }
                    }
                    .onChange(of: selectedID) {
                        withAnimation {
                            proxy.scrollTo(selectedID, anchor: .center)
                        }
                    }
                }
            }
            
        }
    }
}

var restaurants: [Restaurant] = mockRestaurantList
var empty: [Restaurant] = []
#Preview {
    RestaurantList(restaurants: .constant(restaurants), selectedID: .constant(nil))
}
