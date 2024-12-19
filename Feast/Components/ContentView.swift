import SwiftUI

struct ContentView: View {
    @ObservedObject var locationManager: LocationManager
    @State private var restaurantList: [Restaurant] = []
    @State private var radius: Double = 5000
    @State private var minPrice: Int = 1
    @State private var maxPrice: Int = 4
    @State private var keyword: String = ""
    @State private var nextPageToken: String? = nil
    @State private var selectedID: String? = nil
    @State private var locationAlert: Bool = false
    @State private var lastRequestTime: Date?
    @State private var shouldRetry: Bool = false
    @State private var searchError: String? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    ProfileView()
                } label: {
                    HeaderView()
                }
                FiltersView(radius: $radius, minPrice: $minPrice, maxPrice: $maxPrice)
                    .padding(.leading, 5)
                RestaurantSearch(searchText: $keyword, submitRequest: getNearbyRestaurants)
                MapView(locationManager: locationManager, restaurantList: $restaurantList, radius: $radius, selectedID: $selectedID)
                    .padding(.vertical, 5)
                RestaurantList(restaurants: $restaurantList, selectedID: $selectedID, errorMessage: $searchError)
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
                if(restaurantList.count == 0 || shouldRetry) { getNearbyRestaurants() }
            }
            .alert(isPresented: $locationAlert) {
                Alert(
                    title: Text("Location Access Denied"),
                    message: Text("Please enable location services in your device settings to fetch nearby restaurants."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
//        .navigationBarHidden(true)
//        .navigationBarBackButtonHidden(true)
    }
    
    func getNearbyRestaurants() {
        if ProcessInfo.processInfo.environment["UITestMockUser"] == "true" {
            if ProcessInfo.processInfo.environment["NoRestaurants"] == "true" {
                return
            }
            #if DEBUG
            restaurantList = mockRestaurantList
            #endif
            return
        }
        let now = Date()
        if !shouldRetry, let lastTime = lastRequestTime, now.timeIntervalSince(lastTime) < 2.0 {
            return
        }
        lastRequestTime = now
        guard let lat = locationManager.userLocation?.coordinate.latitude,
              let long = locationManager.userLocation?.coordinate.longitude
        else {
            AnalyticsManager.shared.logEvent(name: "Search_FAILED", params: ["error": "lat/long not available to search"])
            shouldRetry = true
            return
        }
        shouldRetry = false
        
        let location: Location = Location(lng: long, lat: lat)
        var params = [
            "location": locationManager.generalizedLocation,
            "keyword": keyword,
            "radius": "\(radius) m",
            "minPrice": "\(minPrice)",
            "maxPrice": "\(maxPrice)"
        ]
        fetchNearbyRestaurants(keyword: keyword, location: location, radius: radius, minPrice: minPrice, maxPrice: maxPrice, openNow: true) { result in
            switch result {
            case .success(let result):
                AnalyticsManager.shared.logSearch(params: params)
                let restaurants = result.results
                nextPageToken = result.next_page_token
                restaurantList = restaurants
                if result.results.isEmpty {
                    searchError = "Nothing found within search parameters"
                } else {
                    searchError = nil
                }
                selectedID = nil
            case .failure(let error):
                let errorMessage = error.localizedDescription
                params["error"] = firebaseParameter(string: errorMessage)
                AnalyticsManager.shared.logEvent(name: "Search_FAILED", params: params)
                searchError = errorMessage
            }
            keyword = ""
        }
    }
}

#if DEBUG
#Preview {
    ContentView(locationManager: MockLocationManager())
}
#endif
