//
//  MapViewController.swift
//  MapsAndLocations
//
//  Created by Lesha Miroshnik on 4/8/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    let manager = CLLocationManager()
    var places: [Place] = Place.allPlaces()
    var place: Place?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.delegate = self
        mapView.mapType = .hybrid
        segmentedControl.selectedSegmentIndex = 2
        
        addPinsOfPlaces()
        if let place = self.place {
            let coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        } else {
            let coordinate = CLLocationCoordinate2D(latitude: places[0].latitude, longitude: places[0].longitude)
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func addPinsOfPlaces() {
        for place in places {
            let coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            let pin: AnnotationPin?
            switch place.type {
            case .school:
                pin = AnnotationPin(title: place.title, subtitle: place.subtitle, coordinate: coordinate, type: .red)
            case .nature:
                pin = AnnotationPin(title: place.title, subtitle: place.subtitle, coordinate: coordinate, type: .green)
            case .museum:
                pin = AnnotationPin(title: place.title, subtitle: place.subtitle, coordinate: coordinate, type: .blue)
            case .town:
                pin = AnnotationPin(title: place.title, subtitle: place.subtitle, coordinate: coordinate, type: .black)
            }
            mapView.addAnnotation(pin!)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = MKMarkerAnnotationView()
        guard let annotation = annotation as? AnnotationPin else {return nil}
        
        var identifier = ""
        var color = UIColor.red
        switch annotation.type{
            case .red:
                identifier = "RedPin"
                color = .red
            case .black:
                identifier = "BlackPin"
                color = .black
            case .blue:
                identifier = "BluePin"
                color = .blue
            case .green:
                identifier = "GreenPin"
                color = .green
        }
        
        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            annotationView = dequedView
        } else{
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationView.markerTintColor = color
        annotationView.glyphTintColor = .yellow
        annotationView.clusteringIdentifier = identifier
        return annotationView
    }
    
    @IBAction func geolocationButton(_ sender: UIButton) {
        self.manager.requestWhenInUseAuthorization()
        self.manager.startUpdatingLocation()
    }
    
    @IBAction func segmentedControlSwitchCase(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                mapView.mapType = .standard
            case 1:
                mapView.mapType = .satellite
            case 2:
                mapView.mapType = .hybrid
            default:
                break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)

        let region: MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
        mapView.setRegion(region, animated: true)

        self.mapView.showsUserLocation = true
        manager.stopUpdatingLocation()
    }
    
}
