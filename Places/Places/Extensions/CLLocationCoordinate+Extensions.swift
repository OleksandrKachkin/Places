//
//  CLLocationCoordinate+Extensions.swift
//  Places
//
//  Created by Oleksandr Kachkin on 14.07.2022.
//

import CoreLocation

extension CLLocationCoordinate2D: CustomStringConvertible {
  public var description: String {
    let lat = String(format: "%.6f", latitude)
    let lng = String(format: "%.6f", longitude)
    return "\(lat),\(lng)"
  }
}
