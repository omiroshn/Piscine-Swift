//
//  ViewController.swift
//  AkaGoogleMaps
//
//  Created by Lesha Miroshnik on 4/14/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController, LocateOnTheMap {
    
    var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    
    var searchResultsController: SearchResultsController!
    var resultsArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView = GMSMapView(frame: view.bounds)
        view.addSubview(mapView)
        
        searchResultsController = SearchResultsController()
        searchResultsController.delegate = self
        
    }
    
    func createMarker(withTitle title: String, withSnipped snipped: String, withPosition pos: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = pos
        marker.title = title
        marker.snippet = snipped
        marker.map = mapView
    }
    
    @IBAction func searchWithAddress(_ sender: UIBarButtonItem) {
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchBar.delegate = self
        self.present(searchController, animated: true, completion: nil)
    }
    
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        DispatchQueue.main.async { () -> Void in
            let position = CLLocationCoordinate2DMake(lat, lon)
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
            let marker = GMSMarker(position: position)
            self.mapView.camera = camera
            marker.title = "Address : \(title)"
            marker.map = self.mapView
        }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.isTrafficEnabled = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 16.5, bearing: 0, viewingAngle: 0)
        locationManager.stopUpdatingLocation()
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let placeClient = GMSPlacesClient()
        placeClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error: Error?) -> Void in
            self.resultsArray.removeAll()
            if results == nil {
                return
            }

            for results in results! {
                if let result = results as? GMSAutocompletePrediction {
                    print(result.attributedFullText.string)
                    self.resultsArray.append(result.attributedFullText.string)
                }
            }
            self.searchResultsController.reloadDataWithArray(self.resultsArray)
        }
    }
}
