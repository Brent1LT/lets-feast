import Foundation
import CoreLocation
import UIKit

// Define the overall API response structure
struct PlacesResponse: Decodable {
    let results: [Restaurant]
    let status: String
    let next_page_token: String?
    let error_message: String?
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


let MAX_ERROR_LENGTH = 95

func fetchNearbyRestaurants(keyword: String, location: Location, radius: Double, minPrice: Int, maxPrice: Int, openNow: Bool, completion: @escaping (Result<PlacesResponse, Error>) -> Void) {
    let baseUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    
    var components = URLComponents(string: baseUrl)
    components?.queryItems = [
        URLQueryItem(name: "keyword", value: keyword),
        URLQueryItem(name: "maxprice", value: "\(maxPrice)"),
        URLQueryItem(name: "minprice", value: "\(minPrice)"),
        URLQueryItem(name: "radius", value: "\(radius)"),
        URLQueryItem(name: "location", value: "\(location.lat),\(location.lng)"),
        URLQueryItem(name: "type", value: "restaurant"),
        URLQueryItem(name: "key", value: APIKeys.googleAPIKey)
    ]
    
    guard let url = components?.url else {
        print("Invalid URL")
        return
    }
    
    // Create a URLRequest to add custom headers
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            let errorMessage = error.localizedDescription
            AnalyticsManager.shared.logEvent(name: "NetworkConnection_FAILED", params: ["error": firebaseParameter(string: errorMessage)])
            completion(.failure(error))
            return
        }
        
        
        
        guard let data = data else {
            print("Error no data received.")
            AnalyticsManager.shared.logEvent(name: "NoDataReceivedFromSearch", params: ["keyword": keyword, "radius": "\(radius)", "minPrice": "\(minPrice)", "maxPrice": "\(maxPrice)"])
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received."])))
            return
        }
        
        do {
            let responseJSON = try JSONDecoder().decode(PlacesResponse.self, from: data)
            
            switch responseJSON.status {
            case "OK", "ZERO_RESULTS":
                // If everything is fine, return the results
                completion(.success(responseJSON))
            default:
                let errorMessage = responseJSON.error_message ?? "no error message"
                let apiError = NSError(domain: "APIError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid API response status: \(responseJSON.status): \(errorMessage)"])
                completion(.failure(apiError))
            }
        } catch {
            AnalyticsManager.shared.logEvent(name: "RestaurantDecode_FAILED", params: ["error": firebaseParameter(string: error.localizedDescription)])
            print("JSON decoding error: \(error)")
            completion(.failure(error))
        }
    }.resume()
}

func fetchImageData(from url: String) async -> UIImage? {
    guard let url = URL(string: url) else { return nil }
    
    var request = URLRequest(url: url)
    request.setValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")

    do {
        let (data, _) = try await URLSession.shared.data(for: request)
        return UIImage(data: data)
    } catch {
        print("Failed to fetch image: \(error.localizedDescription)")
        return nil
    }
}

func firebaseParameter(string: String) -> String {
    return string.count > MAX_ERROR_LENGTH ? string.prefix(MAX_ERROR_LENGTH) + "..." : string
}
