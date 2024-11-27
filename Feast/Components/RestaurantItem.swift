import SwiftUI
import MapKit

struct RestaurantItem: View {
    @State var restaurant: Restaurant
    @State private var image: UIImage?
    
    var body: some View {
        HStack(alignment: .center) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 200, height: 150)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .padding(.trailing, 10)
            } else {
                ProgressView()
                    .frame(width: 200, height: 150)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .padding(.trailing, 10)
                    .task {
                        image = await fetchImageData(from: restaurant.thumbnailURL ?? "")
                    }
            }
            
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
                        .accessibilityIdentifier("\(restaurant.name) rating")
                    
                    if restaurant.rating != nil {
                        Image(systemName: "star.fill")
                            .font(.subheadline)
                            .foregroundColor(.yellow)
                    }
                }

                VStack(alignment: .leading, spacing: 3) {
                    Button {
                        let lat = restaurant.geometry.location.lat
                        let long = restaurant.geometry.location.lng
                        
                        let coord = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coord))
                        mapItem.name = restaurant.name
                        
                        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
                        AnalyticsManager.shared.logEvent(name: "Open_in_Apple_Maps", params: ["restaurant": restaurant.name])
                    } label: {
                        Text("Open in Apple Maps")
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                    .accessibilityIdentifier("\(restaurant.name) open in Apple Maps")
                    .padding(.top, 5)
                    
                    Button {
                        let lat = restaurant.geometry.location.lat
                        let long = restaurant.geometry.location.lng
                        
                        let googleMapsURL = URL(string: "comgooglemaps://?daddr=\(lat),\(long)&directionsmode=driving")
                        
                        if let url = googleMapsURL, UIApplication.shared.canOpenURL(url) {
                            AnalyticsManager.shared.logEvent(name: "Open_in_Google_Maps", params: ["restaurant": restaurant.name, "platform": "mobile"])
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            
                        } else {
                            // Fallback: Open in browser if the Google Maps app isn't installed
                            AnalyticsManager.shared.logEvent(name: "Open_in_Google_Maps", params: ["restaurant": restaurant.name, "platform": "browser"])
                            let browserURL = URL(string: "https://www.google.com/maps/dir/?api=1&destination=\(lat),\(long)&travelmode=driving")
                            if let url = browserURL {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }
                    } label: {
                        Text("Open in Google Maps")
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                    .padding(.top, 5)

                }
                
                if restaurant.priceLevel != nil {
                    Spacer()
                    Text("Price")
                        .font(.subheadline)
                    HStack(spacing: 3) {
                        ForEach(1...(restaurant.priceLevel ?? 1), id: \.self) { number in
                            Image(systemName: "dollarsign.circle")
                                .foregroundColor(.green)
                                .font(.caption)
                        }
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
}

#if DEBUG
#Preview {
    RestaurantItem(restaurant: mockRestaurantList[1])
}
#endif
