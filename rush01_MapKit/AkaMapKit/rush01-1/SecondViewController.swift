//
//  SecondViewController.swift
//  rush01-1
//
//  Created by Illia NAZARINA on 4/14/19.
//  Copyright © 2019 Illia NAZARINA. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SecondViewController: UIViewController {

    var departureAnnotation : MKPointAnnotation = MKPointAnnotation()
    var destinationAnnotation : MKPointAnnotation = MKPointAnnotation()
    
    @IBOutlet weak var departureSearchBar: UISearchBar!
    @IBOutlet weak var destinationSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backToFirstView(_ sender: UIButton) {
        self.performFirstRequest(completionHandler: { (annotation1, error) in
            
            if annotation1 != nil && error == nil {
                self.departureAnnotation = annotation1!
                self.performSecondRequest(completionHandler: {(annotation2, error) in
                    
                    if annotation2 != nil && error == nil {
                        self.destinationAnnotation = annotation2!
                        
                        self.performSegue(withIdentifier: "unwindToMainView", sender: self)
                    } else {
                        self.showAlert(withTitle: "Error", withMessage: "Second location was't found")
                    }
                })
            } else {
                self.showAlert(withTitle: "Error", withMessage: "First location was't found")
            }
        })
    }
    
    func performFirstRequest(completionHandler:@escaping (MKPointAnnotation?, Error?) -> Void){
        
        if (!(self.departureSearchBar.text?.isEmpty)!) {

            let searchRequest = MKLocalSearchRequest()
            searchRequest.naturalLanguageQuery = self.departureSearchBar.text
            
            let activeSearch = MKLocalSearch(request: searchRequest)
            activeSearch.start { (result, error) in
                
                if result == nil {
                    self.showAlert(withTitle: "Error", withMessage: "Error during requesting location from departure searchfield")
                    completionHandler(nil, error)
                } else {
                    let lat = result?.boundingRegion.center.latitude
                    let lng = result?.boundingRegion.center.longitude
                    
                    let newLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
                    let annotation = MKPointAnnotation()
                    annotation.title = result?.mapItems[0].name
                    annotation.coordinate = newLocation
                    
                    completionHandler(annotation, nil)
                }
            }
        }
    }
    
    func performSecondRequest(completionHandler:@escaping (MKPointAnnotation?, Error?) -> Void){

        if (!(self.destinationSearchBar.text?.isEmpty)!) {
            
            let searchRequest = MKLocalSearchRequest()
            searchRequest.naturalLanguageQuery = self.destinationSearchBar.text
            
            let activeSearch = MKLocalSearch(request: searchRequest)
            activeSearch.start { (result, error) in
                
                if result == nil {
                    self.showAlert(withTitle: "Error", withMessage: "Error during requesting location from departure searchfield")
                    completionHandler(nil, error)
                } else {
                    let lat = result?.boundingRegion.center.latitude
                    let lng = result?.boundingRegion.center.longitude
                    
                    let newLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
                    
                    let annotation = MKPointAnnotation()
                    annotation.title = result?.mapItems[0].name
                    annotation.coordinate = newLocation
                    
                    completionHandler(annotation, nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToMainView" {
            let destVC = segue.destination as! ViewController
            destVC.departureAnnotation = self.departureAnnotation
            destVC.destinationAnnotation = self.destinationAnnotation
        }
    }
}

extension SecondViewController {
    
    func showAlert(withTitle title: String, withMessage msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
