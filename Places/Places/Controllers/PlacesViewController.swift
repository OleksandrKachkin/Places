//
//  PlacesViewController.swift
//  Places
//
//  Created by Oleksandr Kachkin on 19.07.2022.
//

import UIKit

class PlacesViewController: UIViewController {
  
  var networkManager = NetworkManager()
  var placesArray = [GooglePlace]()
  private let cellReuseIdentifier = "Cell"
  
  @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
      
      tableView.rowHeight = UITableView.automaticDimension // Dynamic Row Height

      let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
      self.tableView.register(nib, forCellReuseIdentifier: cellReuseIdentifier)
    }
  
  func configureWithPlaces(_ places: [GooglePlace]) {
    self.placesArray = places
    if let tableView = tableView {
      tableView.reloadData()
    }
  }
  
  
  @IBAction func doneButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
}
// MARK: - TableView Data Source & TableView Delegate
extension PlacesViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return placesArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CustomTableViewCell
    let place = placesArray[indexPath.row]
    
    cell.nameLabel.text = place.name
    cell.addressLabel.text = place.address
    if let rating = place.rating {
      cell.ratingPLace.text = "Рейтинг \(rating) баллов"
    } else {
      cell.ratingPLace.text = ""
    }
    networkManager.getPlaceIcon(urlImage: place.icon) { (result) in
      switch result {
      case .success(let data):
        cell.iconOfPlace.image = UIImage(data: data)
      case .failure(let error):
        print(error)
      }
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
