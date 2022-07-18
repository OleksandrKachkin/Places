//
//  PlaceMarker.swift
//  Places
//
//  Created by Oleksandr Kachkin on 13.07.2022.
//

import Foundation
import GoogleMaps

class PlaceMarker: GMSMarker {
  let place: GooglePlace
  
  init(place: GooglePlace, availableTypes: [String]) {
    self.place = place
    super.init()
    
    position = place.coordinate
    groundAnchor = CGPoint(x: 0.5, y: 1)
    appearAnimation = .pop
    
    var foundType = "restaurant"
    let possibleTypes = availableTypes.count > 0 ? availableTypes : ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
    for type in place.types {
      if possibleTypes.contains(type) {
        foundType = type
        break
      }
    }
    icon = UIImage(named: foundType+"_pin")
  }
}
