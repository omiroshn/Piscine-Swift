//
//  ViewController.swift
//  rush01-1
//
//  Created by Illia NAZARINA on 4/14/19.
//  Copyright © 2019 Illia NAZARINA. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, UISearchBarDelegate {

    var locationManager = CLLocationManager()
    
    var departureAnnotation : MKPointAnnotation = MKPointAnnotation()
    var destinationAnnotation : MKPointAnnotation = MKPointAnnotation()
    
    var departureLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var destinationLocation : CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted, .denied:
            self.showAlert(withTitle: "Error", withMessage: "Location Servises are restricted!")
            break
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            break
        }
    }
    
    func centerLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted, .denied:
            self.showAlert(withTitle: "Error", withMessage: "Location Servises are restricted!")
            break
        case .authorizedWhenInUse, .authorizedAlways:
            let coordinates : CLLocationCoordinate2D = locationManager.location!.coordinate
            self.departureLocation = coordinates
            
            let userRegion = MKCoordinateRegionMakeWithDistance(coordinates, 5000, 5000)
            self.mapView.setRegion(userRegion, animated: true)
            locationManager.stopUpdatingLocation()
            break
        }
    }
    
    @IBAction func findMeButton(_ sender: UIButton) {
        self.centerLocation()
    }
    
    @IBAction func findRouteAction(_ sender: UIButton) {
        performSegue(withIdentifier: "showSearch", sender: self)
    }
    
    @IBAction func createPathOnFirstView(_ sender: UIButton) {
        
        if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied {
            self.showAlert(withTitle: "Error", withMessage: "Location Servises are restricted!")
            return
        }
        let temp: CLLocationCoordinate2D = locationManager.location!.coordinate
        
        self.departureLocation = CLLocationCoordinate2D(latitude: temp.latitude, longitude: temp.longitude)
        
        self.mapView.removeOverlays(mapView.overlays)
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        self.mapView.addAnnotation(self.destinationAnnotation)
        
        let departurePlacemark = MKPlacemark(coordinate: self.departureLocation)
        let destinationPlacemark = MKPlacemark(coordinate: self.destinationLocation)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = MKMapItem(placemark: departurePlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (result, error) in
            guard let directionResponse = result else {
                if let error = error {
                    self.showAlert(withTitle: "Error", withMessage: error.localizedDescription)
                }
                return
            }
            let route = directionResponse.routes[0]
            self.mapView.add(route.polyline, level: .aboveRoads)
            
            
            let rect = route.polyline.boundingMapRect
            var newRegion = MKCoordinateRegionForMapRect(rect)
            newRegion.span.latitudeDelta *= 1.5
            newRegion.span.longitudeDelta *= 1.5
            self.mapView.setRegion(newRegion, animated: true)
        }
    }
    
    @IBAction func searchView(_ sender: UIBarButtonItem) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (result, error) in
            if result == nil {
                self.showAlert(withTitle: "Error", withMessage: "Error during requesting location")
            } else {
                let annotations: [MKAnnotation] = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                
                let lat = result?.boundingRegion.center.latitude
                let lng = result?.boundingRegion.center.longitude
                
                let coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
                self.destinationLocation = coord
                
                self.createPin(withTitle: self.departureAnnotation.title, withCoordinate: self.departureAnnotation.coordinate)
                let annotation = MKPointAnnotation()
                annotation.title = result?.mapItems[0].name
                annotation.coordinate = coord

                self.destinationAnnotation = annotation
                self.mapView.addAnnotation(self.destinationAnnotation)
                
                let coords = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
                let newRegion = MKCoordinateRegionMakeWithDistance(coords, 500, 500)
                self.mapView.setRegion(newRegion, animated: true)
                
            }
        }
        
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    @IBAction func unwindToMain(segue:UIStoryboardSegue) {
        
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        self.mapView.removeOverlays(mapView.overlays)
        
        self.createPin(withTitle: self.departureAnnotation.title, withCoordinate: self.departureAnnotation.coordinate)
        self.createPin(withTitle: self.destinationAnnotation.title, withCoordinate: self.destinationAnnotation.coordinate)
        
        let departurePlacemark = MKPlacemark(coordinate: self.departureAnnotation.coordinate)
        let destinationPlacemark = MKPlacemark(coordinate: self.destinationAnnotation.coordinate)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = MKMapItem(placemark: departurePlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (result, error) in
            guard let directionResponse = result else {
                if let error = error {
                    self.showAlert(withTitle: "Error", withMessage: error.localizedDescription)
                }
                return
            }
            let route = directionResponse.routes[0]
            self.mapView.add(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            var newRegion = MKCoordinateRegionForMapRect(rect)
            newRegion.span.latitudeDelta *= 1.5
            newRegion.span.longitudeDelta *= 1.5
            self.mapView.setRegion(newRegion, animated: true)
        }
    }
    
    @IBAction func goToFirstVC(segue:UIStoryboardSegue) {}

}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 2.0
        return renderer
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.centerLocation()
    }
}

extension ViewController {
    
    func showAlert(withTitle title: String, withMessage msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func createPin(withTitle title: String?, withCoordinate coord: CLLocationCoordinate2D) {
        let pin = MKPointAnnotation()
        pin.title = title
        pin.coordinate = coord
        mapView.addAnnotation(pin)
    }
}

