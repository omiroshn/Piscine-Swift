//
//  AnnotationPin.swift
//  MapsAndLocations
//
//  Created by Lesha Miroshnik on 4/9/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit
import MapKit

enum PinColor {
    case red
    case black
    case blue
    case green
}

class AnnotationPin: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var type: PinColor
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, type: PinColor) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.type = type
    }
}
