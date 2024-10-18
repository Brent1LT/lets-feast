//
//  RestaurantsListPreview.swift
//  Feast
//
//  Created by Brent Bumann on 9/11/24.
//

import Foundation

var geometry = Geometry(location: Location(lng: 123, lat: 123))

var samplePhoto = Photo(photo_reference: "AdCG2DPcze9_iw6XER1QzAJkSZG_RRBnIkq-SJ2Y44eDAJTBiz7AVJBsNlZCwqvr8Duw2Ap_3uCaY2P7aa6lk1G_f6yZ9lUkDXbLDfQlHGosTgHplcWoTS8iJHe96Qs_iXczCkkyuTxreUJHUqjf-1EWvkhlRFKbZsEVc67BEAuixcEcpgcc")

var restaurant1 = Restaurant(name: "Italian Bistro", photos: [samplePhoto], geometry: geometry)
var restaurant2 = Restaurant(name: "Sushi Palace", photos: [samplePhoto], geometry: geometry)
var restaurant3 = Restaurant(name: "Burger Town", photos: [samplePhoto], geometry: geometry)
var restaurant4 = Restaurant(name: "Pasta House", photos: [samplePhoto], geometry: geometry)
var restaurant5 = Restaurant(name: "Taco Fiesta",photos: [samplePhoto], geometry: geometry)
var restaurant6 = Restaurant(name: "Pizza Place", photos: [samplePhoto], geometry: geometry)

var mockRestaurantList = [restaurant1, restaurant2, restaurant3, restaurant4, restaurant5, restaurant6]
