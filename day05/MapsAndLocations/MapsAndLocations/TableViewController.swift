//
//  TableViewController.swift
//  MapsAndLocations
//
//  Created by Lesha Miroshnik on 4/9/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var places: [Place] = Place.allPlaces()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - TableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let place = places[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        
        cell.setPlace(withPlace: place)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "tableToMap", sender: cell)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! TableViewCell
        let destvc = segue.destination as! MapViewController
        destvc.place = cell.place
    }

}
