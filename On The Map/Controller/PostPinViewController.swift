//
//  PostPinViewController.swift
//  On The Map
//
//  Created by Jason Yu on 6/15/20.
//  Copyright © 2020 Jason Yu. All rights reserved.
//

import UIKit
import MapKit

class PostPinViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var locationManger: CLLocationManager?
    var firstName: String?
    var lastName: String?
    var mediaUrl: String?
    var location: String?
    var lat: Double?
    var long: Double?

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        // Do any additional setup after loading the view.
        print("POSTPIN: \(String(describing: lat))")
        zoomToLatestLocation()
    }
    
    @IBAction func finishTapped(_ sender: Any) {
        guard let firstName = firstName, let lastName = lastName, let mediaUrl = mediaUrl, let location =  location, let lat = lat, let long = long else {
            let alert = UIAlertController(title: "Error getting User Data", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        UserAPI.shared.postUserRequest(firstName: firstName, lastName: lastName, mediaUrl: mediaUrl, location: location, lat: lat, long: long) { result in
            switch result {
            case .success(_):
                print("Success POSTING::")

                DispatchQueue.main.async {
                    if let nav = self.navigationController {
                        nav.popViewController(animated: false)
                        nav.popViewController(animated: true)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            case .failure(let error):
                print("Failure POSTING:: \(error)")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Failed Post - Please try again", message: "\(error)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    func zoomToLatestLocation() {
        guard let lat = lat, let long = long, let firstName = firstName, let lastName = lastName, let mediaUrl = mediaUrl else { return }
        let postLocation = CLLocation(latitude: lat, longitude: long)
        let regionRadius: CLLocationDistance = 2000000.0
        let region = MKCoordinateRegion(center: postLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
        addAnnotations(title: "\(String(describing: firstName)) \(String(describing: lastName))", subTitle: "\(String(describing: mediaUrl))", coordinate: CLLocationCoordinate2DMake(lat, long))
        
        mapView.delegate = self
        
        activityIndicator.stopAnimating()
    }

    func addAnnotations(title: String, subTitle: String, coordinate: CLLocationCoordinate2D) {
        let userAnnotation = UserMarker(title: title, subtitle: subTitle, coordinate: coordinate)
        mapView.addAnnotation(userAnnotation)
    }
}
