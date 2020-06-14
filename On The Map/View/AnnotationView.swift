//
//  AnnotationView.swift
//  On The Map
//
//  Created by Jason Yu on 6/13/20.
//  Copyright © 2020 Jason Yu. All rights reserved.
//

import Foundation
import MapKit

class AnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let annotation = newValue as? UserMarker else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//            glyphImage = UIImage(imageLiteralResourceName: "udacityImage")
        }
    }
}
