//
//  PlaceListTableViewCell.swift
//  PlacesV2_TEST
//
//  Created by Oleksandr Kachkin on 14.07.2022.
//

import UIKit

class PlaceListTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var placeIcon: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var placeRatingLabel: UILabel!
    
    func configure(with model: GooglePlace) {
        
        nameLabel.text = model.name
        addressLabel.text = model.address
        
        let url = URL(string: model.icon)
        if let data = try? Data(contentsOf: url!) {
            placeIcon.image = UIImage(data: data)
        }
        
        if let rating = model.rating {
            placeRatingLabel.text = "Рейтинг \(rating) баллов"
        } else {
            placeRatingLabel.text = ""
        }
    }
}
