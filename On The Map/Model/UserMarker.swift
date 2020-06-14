//
//  UserMarker.swift
//  On The Map
//
//  Created by Jason Yu on 6/12/20.
//  Copyright © 2020 Jason Yu. All rights reserved.
//

import Foundation
import MapKit

class UserMarker: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
    }
}
