//
//  RestaurantsListPreview.swift
//  Feast
//
//  Created by Brent Bumann on 9/11/24.
//

import Foundation

var geometry = Geometry(location: Location(lng: 123, lat: 123))

var jack = Photo(photo_reference: "AdCG2DPcze9_iw6XER1QzAJkSZG_RRBnIkq-SJ2Y44eDAJTBiz7AVJBsNlZCwqvr8Duw2Ap_3uCaY2P7aa6lk1G_f6yZ9lUkDXbLDfQlHGosTgHplcWoTS8iJHe96Qs_iXczCkkyuTxreUJHUqjf-1EWvkhlRFKbZsEVc67BEAuixcEcpgcc")
var panda = Photo(photo_reference:"AdCG2DMS3-iHEYQxtlMrH3F0Ot2gCPb9VNWwl-ZybgEE_jFFBtPFUshYHvLX1wFsGMhzZcJCyHAsNR3KdR9D0TLoZMZWI_71Z91JvgpO4y11EZ6aPJx8nlRXE38tR8rBmnCtjnt8mg-GxfDxG-JLvYB0Ba_Pi9x9Ew1C_vY_c_C-ZnbVKWI8")
var donalds = Photo(photo_reference: "AdCG2DP9pDyK9BflEGqbkZp7mZkS1YjoeNua4T1LM8j1k99UIQJD_8rUUbdThxVgn_SFYWwIROrZjVoo0j2qJmdQTE4K757_GMphlZ71YPDcgpVD_u7Gj_eA7Tve2ws-7_Etr7vDWdfzkEBS1tUcXaCHgKy20HTLMls_dJjHo1wiyz9HO5yK")
var subway = Photo(photo_reference: "AdCG2DPX03TePJ6qVXiJmcLgTr3mw5AkmS0KSMPW_vEvA3ZI8hLr4V1EHuMh9jWdXYu5N_dXR6OWFUnMO7GISSsDENmDNmyr6POJAx_8gEJ7TFKyKbejY4IM2_3duNGyMdwHyZH22kaZmRRc7Rdh8MjfLBAd18RFPN65xIB5j5-xBTl8UL_Z")

var restaurant1 = Restaurant(id: "1", name: "AdCG2DPX03TePJ6qVXiJmcLgTr3mw5AkmS0KSMPW_vEvA3ZI8hLr4V1EHuMh9jWdXYu5N_dXR6OWFUnMO7GISSsDENmDNmyr6POJAx_8gEJ7TFKyKbejY4IM2_3duNGyMdwHyZH22kaZmRRc7Rdh8MjfLBAd18RFPN65xIB5j5-xBTl8UL_Z", photos: [jack], rating: 4.5, geometry: geometry)
var restaurant2 = Restaurant(id: "2", name: "Sushi Palace", photos: [subway], geometry: geometry)
var restaurant3 = Restaurant(id: "3", name: "Burger Town", photos: [panda], geometry: geometry)
var restaurant4 = Restaurant(id: "4", name: "Pasta House", photos: [donalds], geometry: geometry)
var restaurant5 = Restaurant(id: "5", name: "Taco Fiesta",photos: [jack], geometry: geometry)
var restaurant6 = Restaurant(id: "6", name: "Pizza Place", photos: [], geometry: geometry)

var mockRestaurantList = [restaurant1, restaurant2, restaurant3, restaurant4, restaurant5, restaurant6]
