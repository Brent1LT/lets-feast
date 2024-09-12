//
//  RestaurantsModel.swift
//  Feast
//
//  Created by Brent Bumann on 9/11/24.
//

import Foundation

struct Restaurant: Identifiable {
    var id = UUID()
    var name: String = ""
    var thumbnail: String = ""
}
