import SwiftUI

struct ContentView: View {
    @ObservedObject var locationManager: LocationManager
    @State private var restaurantList: [Restaurant] = []
    @State private var radius: Double = 5000
    @State private var minPrice: Int = 0
    @State private var maxPrice: Int = 4
    @State private var keyword: String = ""
    @State private var nextPageToken: String? = nil
    @State private var selectedID: String? = nil
    
    
    func getNearbyRestaurants() {
        print("Fetching Restaurants...")
//        print("\(locationManager.userLocation)")
        print("Searching with keyword: \(keyword)")
        guard let lat = locationManager.userLocation?.coordinate.latitude,
              let long = locationManager.userLocation?.coordinate.longitude
        else {
            print("User location is not available. Cannot fetch nearby restaurants.")
            return
        }
        
        let location: Location = Location(lng: long, lat: lat)
        fetchNearbyRestaurants(keyword: keyword, location: location, radius: radius, minPrice: minPrice, maxPrice: maxPrice, openNow: true) { result in
            switch result {
            case .success(let result):
                let restaurants = result.results
                nextPageToken = result.next_page_token
                restaurantList = restaurants
                selectedID = nil
            case .failure(let error):
                print("Error fetching nearby restaurants: \(error.localizedDescription)")
                
            }
        }
    }
    
    var body: some View {
        VStack {
            HeaderView()
            FiltersView(radius: $radius, minPrice: $minPrice, maxPrice: $maxPrice)
            RestaurantSearch(searchText: $keyword, submitRequest: getNearbyRestaurants)
            MapView(locationManager: locationManager, restaurantList: $restaurantList, radius: $radius, selectedID: $selectedID)
                .padding(.vertical, 5)
            RestaurantList(restaurants: $restaurantList, selectedID: $selectedID)
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

#Preview {
    ContentView(locationManager: MockLocationManager())
}
