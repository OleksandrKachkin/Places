//
//  GooglePlace.swift
//  Places
//
//  Created by Oleksandr Kachkin on 11.07.2022.
//

import Foundation
import CoreLocation

struct GooglePlace: Codable {
  let icon: String
  let name: String
  let address: String
  let rating: Double?
  let types: [String]
  
  private let geometry: Geometry
  var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: geometry.location.lat, longitude: geometry.location.lng)
  }

  enum CodingKeys: String, CodingKey {
    case rating
    case icon
    case name
    case address = "vicinity"
    case types
    case geometry
  }
}

extension GooglePlace {
  struct Response: Codable {
    let results: [GooglePlace]
    let errorMessage: String?
  }
  
  private struct Geometry: Codable {
    let location: Coordinate
  }
  
  private struct Coordinate: Codable {
    let lat: CLLocationDegrees
    let lng: CLLocationDegrees
  }
}
