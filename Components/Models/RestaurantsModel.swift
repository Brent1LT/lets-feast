//
//  RestaurantsModel.swift
//  Feast
//
//  Created by Brent Bumann on 9/11/24.
//

import Foundation

struct Restaurant: Decodable, Equatable, Identifiable {
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String = ""
    var name: String = ""
    var photos: [Photo] = []
    var thumbnailURL: String? {
        guard let photoReference = photos.first?.photo_reference else { return nil }
        return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&maxheight=400&photoreference=\(photoReference)&key=\(APIKeys.googleAPIKey)"
    }
    var rating: Double?
    let geometry: Geometry
    var vicinity: String = ""
    let priceLevel: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "place_id" // Map `place_id` to `id`
        case priceLevel = "price_level"
        case name
        case photos
        case rating
        case geometry
        case vicinity
    }
}

struct Location: Decodable {
    var lng: Double
    var lat: Double
}

struct Geometry: Decodable {
    let location: Location
}

struct Photo: Decodable {
    var height: Double = 400
    var width: Double = 400
    var photo_reference: String = ""
}
