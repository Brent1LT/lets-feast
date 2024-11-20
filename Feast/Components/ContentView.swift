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
    @State private var locationAlert: Bool = false
    
    
    func getNearbyRestaurants() {
        if ProcessInfo.processInfo.environment["UITestMockUser"] == "true" {
            if ProcessInfo.processInfo.environment["NoRestaurants"] == "true" {
                return
            }
            restaurantList = mockRestaurantList
            return
        } 
        guard let lat = locationManager.userLocation?.coordinate.latitude,
              let long = locationManager.userLocation?.coordinate.longitude
        else {
            AnalyticsManager.shared.logEvent(name: "Search_FAILED", params: ["error": "lat/long not available to search"])
            return
        }
        
        let location: Location = Location(lng: long, lat: lat)
        fetchNearbyRestaurants(keyword: keyword, location: location, radius: radius, minPrice: minPrice, maxPrice: maxPrice, openNow: true) { result in
            switch result {
            case .success(let result):
                AnalyticsManager.shared.logSearch(params: [
                    "location": locationManager.generalizedLocation,
                    "keyword": "\(keyword)",
                    "radius": "\(radius) km",
                    "minPrice": "\(minPrice)",
                    "maxPrice": "\(maxPrice)"
                ])
                let restaurants = result.results
                nextPageToken = result.next_page_token
                restaurantList = restaurants
                selectedID = nil
            case .failure(let error):
                AnalyticsManager.shared.logEvent(name: "Search_FAILED", params: [
                    "location": locationManager.generalizedLocation,
                    "keyword": "\(keyword)",
                    "radius": "\(radius) km",
                    "minPrice": "\(minPrice)",
                    "maxPrice": "\(maxPrice)",
                    "error": "\(error.localizedDescription)"
                ])
                print("Error fetching nearby restaurants: \(error.localizedDescription)")
                
            }
            keyword = ""
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    ProfileView()
                } label: {
                    HeaderView()
                }
                FiltersView(radius: $radius, minPrice: $minPrice, maxPrice: $maxPrice)
                RestaurantSearch(searchText: $keyword, submitRequest: getNearbyRestaurants)
                MapView(locationManager: locationManager, restaurantList: $restaurantList, radius: $radius, selectedID: $selectedID)
                    .padding(.vertical, 5)
                RestaurantList(restaurants: $restaurantList, selectedID: $selectedID)
            }
            .padding(.horizontal, 10)
            .onAppear {
                locationManager.requestLocation()
                if locationManager.isLocationPermissionDenied {
                    AnalyticsManager.shared.logEvent(name: "Location_Denied")
                    locationAlert = true
                }
                getNearbyRestaurants()
            }
            .onChange(of: locationManager.userLocation) {
                // Trigger fetching restaurants only after location is available
                if(restaurantList.count == 0) { getNearbyRestaurants() }
            }
            .alert(isPresented: $locationAlert) {
                Alert(
                    title: Text("Location Access Denied"),
                    message: Text("Please enable location services in your device settings to fetch nearby restaurants."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

#Preview {
    ContentView(locationManager: MockLocationManager())
}
