//
//  NetworkManager.swift
//  Places
//
//  Created by Oleksandr Kachkin on 15.07.2022.
//

import Foundation

struct NetworkManager {
  
  func getPlaceIcon(urlImage: String, completion: @escaping (Result<Data, Error>) -> Void) {
    guard let imageURL = URL(string: urlImage) else { return }
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: imageURL) { data, response, error in
      DispatchQueue.main.async {
        if let error = error {
          print(error)
          completion(.failure(error))
          return
        }
        guard let safeData = data else { return }
        completion(.success(safeData))
      }
    }
    task.resume()
  }
  
  
  func fetchPlace<T:Codable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
    guard let url = URL(string: urlString) else { return }
    URLSession.shared.dataTask(with: url) { data, response, error in
      DispatchQueue.main.async {
        if let error = error {
          print(error)
          completion(.failure(error))
          return
        }
        guard let safeData = data else { return }
        do {
          let resultPlace = try JSONDecoder().decode(T.self, from: safeData)
          completion(.success(resultPlace))
        } catch let jsonError {
          print("Error to decode JSON - \(jsonError)")
          completion(.failure(jsonError))
        }
      }
    }.resume()
  }
  
  //  "https://maps.googleapis.com/maps/api/place/nearbysearch/json?&location=50.467737915814055,30.60221340134575&radius=500&type=cafe&key=AIzaSyDpek2EH_JN6g5D-Na_CJ35qDivjdjDkro"
  
  func fetchPlaceInfo(completion: @escaping (Result<GooglePlace, Error>) -> Void) {
    let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?&location=50.467737915814055,30.60221340134575&radius=500&type=cafe&key=AIzaSyDpek2EH_JN6g5D-Na_CJ35qDivjdjDkro"
    guard let url = URL(string: urlString) else { return }
    URLSession.shared.dataTask(with: url) { data, response, error in
      DispatchQueue.main.async {
        if let error = error {
          print(error)
          completion(.failure(error))
          return
        }
        guard let safeData = data else { return }
        do {
          let resultPlace = try JSONDecoder().decode(GooglePlace.self, from: safeData)
          completion(.success(resultPlace))
        } catch let jsonError{
          print("Error to decode JSON - \(jsonError)")
          completion(.failure(jsonError))
        }
      }
    }.resume()
  }
  
}
