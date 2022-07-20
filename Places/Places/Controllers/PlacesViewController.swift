//
//  PlacesViewController.swift
//  Places
//
//  Created by Oleksandr Kachkin on 19.07.2022.
//

import UIKit

class PlacesViewController: UIViewController {
    
//    private var networkManager = NetworkManager()
    var placesArray = [GooglePlace]()
    private let cellReuseIdentifier = "Cell"
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension // Dynamic Row Height
        
        let nib = UINib(nibName: "PlaceListTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    func configureWithPlaces(_ places: [GooglePlace]) {
        self.placesArray = places
        if let tableView = tableView {
            tableView.reloadData()
        }
    }
    
    
    
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
// MARK: - TableView Data Source & TableView Delegate
extension PlacesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! PlaceListTableViewCell
        let place = placesArray[indexPath.row]
        cell.configure(with: place)
        return cell
    }
    
    
}

// MARK: - TableView Delegate
extension PlacesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
