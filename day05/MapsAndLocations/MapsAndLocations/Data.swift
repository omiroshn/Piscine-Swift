//
//  Data.swift
//  MapsAndLocations
//
//  Created by Lesha Miroshnik on 4/9/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit

enum PlaceType {
    case school
    case nature
    case museum
    case town
}

struct Place : CustomStringConvertible {
    var description: String {
        return "Title: \(self.title), Subtitle: \(self.subtitle), Latitude: \(self.latitude), Longitude: \(self.longitude)"
    }
    var title: String
    var subtitle: String
    var image: UIImage
    var latitude: Double
    var longitude: Double
    var type: PlaceType
    
    static func allPlaces() -> [Place] {
        var tempPlaces: [Place] = []
        
        tempPlaces.append(Place(title: "UNIT Factory", subtitle: "Ukraine National IT school", image: UIImage(named: "UNIT")!, latitude: 50.4688426, longitude: 30.4619423, type: .school))
        tempPlaces.append(Place(title: "Ecole 42", subtitle: "French Programming school", image: UIImage(named: "Ecole_42")!, latitude: 48.8965488, longitude: 2.3162668, type: .school))
        tempPlaces.append(Place(title: "Silicon Valley", subtitle: "Home of Steeve Jobs", image: UIImage(named: "Silicon_Valley")!, latitude: 37.402473, longitude: -122.3212843, type: .school))
        tempPlaces.append(Place(title: "Taj Mahal", subtitle: "The legendary mausoleum in the style of the Mongols", image: UIImage(named: "Taj_Mahal")!, latitude: 27.1750151, longitude: 78.0399612, type: .museum))
        tempPlaces.append(Place(title: "Tour Eiffel", subtitle: "A tower of the 19th century with a height of 324 meters", image: UIImage(named: "Tour_Eiffel")!, latitude: 48.8580948, longitude: 2.2934835, type: .museum))
        tempPlaces.append(Place(title: "Big Ben", subtitle: "Famous London watch", image: UIImage(named: "Big_Ben")!, latitude: 51.5007292, longitude: -0.1268194, type: .town))
        tempPlaces.append(Place(title: "Temple Bar", subtitle: "Famous Irish pub", image: UIImage(named: "Temple_Bar")!, latitude: 53.3455349, longitude: -6.2676304, type: .town))
        tempPlaces.append(Place(title: "Sagrada Familia", subtitle: "Gaudí´s temple in Barcelona", image: UIImage(named: "Sagrada_Familia")!, latitude: 36.7434461, longitude: -4.4256192, type: .nature))
        tempPlaces.append(Place(title: "Niagara Falls", subtitle: "Legedary waterfall", image: UIImage(named: "Niagara_Falls")!, latitude: 43.0828162, longitude: -79.0763516, type: .nature))
        
        return tempPlaces
    }
}
