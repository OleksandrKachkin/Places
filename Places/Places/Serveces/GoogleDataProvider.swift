//
//  GoogleDataProvider.swift
//  Places
//
//  Created by Oleksandr Kachkin on 14.07.2022.
//

import UIKit
import CoreLocation

typealias PlacesCompletion = ([GooglePlace]) -> Void
typealias PhotoCompletion = (UIImage?) -> Void

class GoogleDataProvider {
  private var photosDictionary: [String: UIImage] = [:]
  private var placesTask: URLSessionDataTask?
  private var session: URLSession {
    return URLSession.shared
  }
  
//  "https://maps.googleapis.com/maps/api/place/nearbysearch/json?&location=50.467737915814055,30.60221340134575&radius=500&type=cafe&key=AIzaSyDpek2EH_JN6g5D-Na_CJ35qDivjdjDkro"

  func fetchPlaces(near coordinate: CLLocationCoordinate2D, radius: Double, types:[String], completion: @escaping PlacesCompletion) -> Void {
    var urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(coordinate)&radius=\(radius)&rankby=prominence&sensor=true&key=\(googleApiKey)"
    let typesString = types.count > 0 ? types.joined(separator: "|") : "food"
    urlString += "&types=\(typesString)"
    urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? urlString
    
    guard let url = URL(string: urlString) else {
      completion([])
      return
    }
    
    placesTask = session.dataTask(with: url) { data, response, _ in
      guard let data = data else {
        DispatchQueue.main.async {
          completion([])
        }
        return
      }
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      guard let placesResponse = try? decoder.decode(GooglePlace.Response.self, from: data) else {
        DispatchQueue.main.async {
          completion([])
        }
        return
      }
      
      if let errorMessage = placesResponse.errorMessage {
        print(errorMessage)
      }
      
      DispatchQueue.main.async {
        completion(placesResponse.results)
      }
    }
    placesTask?.resume()
  }
}

