//
//  Utils.swift
//  Feast
//
//  Created by Brent Bumann on 10/16/24.
//

import Foundation

// Define the overall API response structure
struct PlacesResponse: Decodable {
    let results: [Restaurant]
    let status: String
}

func fetchNearbyRestaurants(keyword: String, location: Location, radius: Double, minPrice: Int, maxPrice: Int, openNow: Bool, completion: @escaping (Result<[Restaurant], Error>) -> Void) {
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
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Network error: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        
        
        guard let data = data else {
            print("Error no data received.")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received."])))
            return
        }
        
        do {
            let responseJSON = try JSONDecoder().decode(PlacesResponse.self, from: data)
            
            // Check if response status is "OK"
            if responseJSON.status != "OK" {
                let apiError = NSError(domain: "APIError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid API response status: \(responseJSON.status)"])
                completion(.failure(apiError))
                return
            }
            
            // If everything is fine, return the results
            completion(.success(responseJSON.results))
        } catch {
            print("JSON decoding error: \(error)")
            completion(.failure(error))
        }
    }.resume()
}
