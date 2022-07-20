//
//  LocationManager.swift
//  Pods
//
//  Created by Oleksandr Kachkin on 20.07.2022.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    
    
    // будет менеджер твоей локации. он будет ответственен за все манипуляции с локацией: начиная от запроса пермиссий на использование локации, заканчивая обновлением локации при движении
    // у него будет свой приватный CLLocationManager (это внутренний инструмент для твоего менеджера, и он не должен быть виден другим)
    // и у локейшн менеджера твоего будет протокол для делегирования , с нужными методами, чтоб можно было передавать инфу , когда надо из твоего менеджера тем, кто будет им пользоваться
    
    private let locationManager = CLLocationManager()
    
    func setupLocation() {
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
//            mapView.isMyLocationEnabled = true
//            mapView.settings.myLocationButton = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            return
        case .authorizedWhenInUse:
            return
        case .denied:
            return
        case .restricted:
            locationManager.requestWhenInUseAuthorization()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            // Handle location update
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        mapView.camera = GMSCameraPosition(
            target: location.coordinate,
            zoom: 15,
            bearing: 0,
            viewingAngle: 0)
        fetchPlaces(near: location.coordinate)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
//        то же самое про локейшн менеджера
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.requestLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
}
