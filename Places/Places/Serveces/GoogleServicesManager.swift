//
//  GoogleServicesManager.swift
//  Places
//
//  Created by Oleksandr Kachkin on 20.07.2022.
//

import Foundation
import GoogleMaps
import GooglePlaces

class GoogleServicesManager {
    let googleApiKey = "AIzaSyDpek2EH_JN6g5D-Na_CJ35qDivjdjDkro"
    
    func startServices() {
        GMSServices.provideAPIKey(googleApiKey)
        GMSPlacesClient.provideAPIKey(googleApiKey)
    }
}
