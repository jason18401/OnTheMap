//
//  ViewController.swift
//  On The Map
//
//  Created by Jason Yu on 6/10/20.
//  Copyright © 2020 Jason Yu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapKit: MKMapView!
    var locationManger: CLLocationManager?

    
    var userAnnotations = [UserMarker]()
//    var selectedUserLocation: UserMarker? = nil
    
    var userPlaces = [UserInfo]()
    var selectedUserLocation: UserInfo? = nil
    
    var previousLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserData()
        setupLocation()
        mapKit.register(AnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
//        addAnnotations()
    }

    @IBAction func addItem(_ sender: Any) {
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        dismiss(animated: true) {
            //
        }
    }
    
    @IBAction func locateUserTapped(_ sender: Any) {
        zoomToLatestLocation()
    }
    
    func setupLocation() {
        locationManger = CLLocationManager()
        locationManger?.delegate = self
        locationManger?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        selectedUserLocation = userPlaces.first
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            


            activateLocationServices()
            updateUI()
        } else {
            locationManger?.requestWhenInUseAuthorization()
        }
        
    }
    
    private func activateLocationServices() {
        locationManger?.startUpdatingLocation()
        
        zoomToLatestLocation()
        
    }
    
    func zoomToLatestLocation() {
        guard let currentLocation = locationManger?.location else { return }
        let currentLatLong = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let regionRadius: CLLocationDistance = 2000000.0
        let region = MKCoordinateRegion(center: currentLatLong.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapKit.setRegion(region, animated: true)
//        mapKit.addAnnotation(userPlaces) // as! MKAnnotation)
        
        mapKit.delegate = self
    }
    
    func updateUI() {
        
    }
    
    func loadUserData() {
        UserAPI.shared.requestUserList { result in
            //TODO: Maybe dismiss loading here
            
            switch result {
            case .success(let users):
//                print("RES: \(String(describing: users.results.first?.firstName))")

                for i in users.results {
                    //user data
                    let userModel = UserInfo(firstName: i.firstName, lastName: i.lastName, mediaURL: i.mediaURL, longitude: i.longitude, latitude: i.latitude)
                    
                    print("USERDATA: \(userModel)")
                    //annotations
                    let coordinate = CLLocationCoordinate2D(latitude: i.latitude, longitude: i.longitude)
//                    let userAnnotation = UserMarker(title: "\(i.firstName) \(i.lastName)", subtitle: i.mediaURL, coordinate: coordinate)
                    self.addAnnotations(title: "\(i.firstName) \(i.lastName)", subTitle: i.mediaURL, coordinate: coordinate)
//                    print("USERANNO \(userAnnotation)")
                    
                    
                    
            
                    self.userPlaces.append(userModel)
//                    self.userAnnotations.append(userAnnotation)
                }
                
            case .failure(let error):
                print("ERROR LOADING USERS: \(error)")
            }
        }
    }
    func addAnnotations(title: String, subTitle: String, coordinate: CLLocationCoordinate2D) {
        let userAnnotation = UserMarker(title: title, subtitle: subTitle, coordinate: coordinate)
        mapKit.addAnnotation(userAnnotation)
    }
    
    func addAnnotations() {
        let coordinate = CLLocationCoordinate2D(latitude: 37.4095, longitude: -122.0511)
        let userAnnotation = UserMarker(title: "AIR", subtitle: "yEAG", coordinate: coordinate)
        mapKit.addAnnotation(userAnnotation)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    //checks status of auth
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            activateLocationServices()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if previousLocation == nil {
            previousLocation = locations.first
        } else {
            guard let latest = locations.first else { return }
            let distanceInMeters = previousLocation?.distance(from: latest) ?? 0
            print("distance in meters: \(distanceInMeters)")
            previousLocation = latest
//            addAnnotations()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //provide toast
        print("DIDFAILWITH:")
        print(error.localizedDescription)
    }
    
    

}

extension MapViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
//            annotationView.animatesWhenAdded = true
//            annotationView.titleVisibility = .adaptive
//
//
//            return annotationView
//        }
//
//        return nil
//    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("didSelect")
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("AccessoryControlTapped")
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle!{
                UIApplication.shared.open(URL(string: toOpen)!)
            }
        }
    }
}
