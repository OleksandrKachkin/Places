//
//  MapViewController.swift
//  Places
//
//  Created by Oleksandr Kachkin on 07.07.2022.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var mapCenterPinImage: UIImageView!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet private weak var pinImageVerticalConstraint: NSLayoutConstraint!
  @IBOutlet weak var blurredImageView: UIImageView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  private var places: [GooglePlace]?
  private var searchedTypes = ["cafe", "restaurant", "bakery", "bar", "grocery_or_supermarket"]
  private let locationManager = CLLocationManager()
  private let dataProvider = GoogleDataProvider()
  private let searchRadius: Double = 5000
}

// MARK: - Lifecycle
extension MapViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    activityIndicator.startAnimating()
    activityIndicator.hidesWhenStopped = true
    blurredImageView.applyBlurEffect()
    
    locationManager.delegate = self
    
    if CLLocationManager.locationServicesEnabled() {
      locationManager.requestLocation()
      mapView.isMyLocationEnabled = true
      mapView.settings.myLocationButton = true
    } else {
      locationManager.requestWhenInUseAuthorization()
    }
    
    mapView.delegate = self
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let navigation = segue.destination as? UINavigationController,
          let controller = navigation.topViewController as? PlacesViewController
    else {
      return
    }
    controller.configureWithPlaces(places ?? [])
  }
  
}

// MARK: - Actions
extension MapViewController {
  
  @IBAction func refreshPlaces(_ sender: Any) {
    fetchPlaces(near: mapView.camera.target)
  }
  
  func fetchPlaces(near coordinate: CLLocationCoordinate2D) {
    mapView.clear()
    blurredImageView.removeBlurEffect()
    activityIndicator.stopAnimating()
    
    dataProvider.fetchPlaces(near: coordinate, radius: searchRadius, types: searchedTypes
    ) { [weak self] places in
      guard let self = self else { return }
      self.places = places
      places.forEach { place in
        let marker = PlaceMarker(place: place, availableTypes: self.searchedTypes)
        marker.map = self.mapView
      }
      
      if let navigation = self.presentedViewController as? UINavigationController,
         let controller = navigation.topViewController as? PlacesViewController {
        controller.configureWithPlaces(places)
      }
    }
  }
  
  func reverseGeocode(coordinate: CLLocationCoordinate2D) {
    let geocoder = GMSGeocoder()
    
    geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
      self.addressLabel.unlock()
      
      guard
        let address = response?.firstResult(),
        let lines = address.lines
      else {
        return
      }
      
      self.addressLabel.text = lines.joined(separator: "\n")
      
      let labelHeight = self.addressLabel.intrinsicContentSize.height
      let topInset = self.view.safeAreaInsets.top
      self.mapView.padding = UIEdgeInsets(
        top: topInset,
        left: 0,
        bottom: labelHeight,
        right: 0)
      
      UIView.animate(withDuration: 0.25) {
        self.pinImageVerticalConstraint.constant = (labelHeight - topInset) * 0.5
        self.view.layoutIfNeeded()
      }
    }
  }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    guard status == .authorizedWhenInUse else {
      return
    }
    
    locationManager.requestLocation()
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
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
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
}

// MARK: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    reverseGeocode(coordinate: position.target)
  }
  
  func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
    addressLabel.lock()
    
    // Пин должен снова появиться в какой-то момент.
    // Это проверяет, было ли движение вызвано жестом пользователя. Если это так, он показывает булавку местоположения, используя fadeIn(_:). Он также устанавливает для выбранного маркера карты значение nil, чтобы удалить представленный в данный момент infoView.
    if gesture {
      mapCenterPinImage.fadeIn(0.25)
      mapView.selectedMarker = nil
    }
  }
  
  func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
    guard let placeMarker = marker as? PlaceMarker else {
      return nil
    }
    guard let infoView = UIView.viewFromNibName("MarkerView") as? MarkerView else {
      return nil
    }
    
    infoView.nameLabel.text = placeMarker.place.name
    infoView.addressLabel.text = placeMarker.place.address
    
    return infoView
  }
  
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    mapCenterPinImage.fadeOut(0.25)
    return false
  }
  
  // Этот метод запускается, когда пользователь нажимает кнопку «Найти», в результате чего карта центрируется на местоположении пользователя. Он также возвращает false, чтобы не переопределять поведение кнопки по умолчанию.
  func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
    mapCenterPinImage.fadeIn(0.25)
    mapView.selectedMarker = nil
    return false
  }
  
}
