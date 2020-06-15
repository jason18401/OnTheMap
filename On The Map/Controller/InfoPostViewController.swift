//
//  InfoPostViewController.swift
//  On The Map
//
//  Created by Jason Yu on 6/15/20.
//  Copyright © 2020 Jason Yu. All rights reserved.
//

import UIKit
import CoreLocation

class InfoPostViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    lazy var geocoder = CLGeocoder()
    var latitude: Double?
    var longitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.hidesWhenStopped = true
    }
    
    @IBAction func findLocationTapped(_ sender: Any) {
        activityIndicator.startAnimating()
        
        if linkTextField.text == nil {
            let alert = UIAlertController(title: "Enter Location", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        
        geocoder.geocodeAddressString(locationTextField.text!) { [weak self] placemarks, error in
            guard let placemarks = placemarks else {
                
                DispatchQueue.main.async {
                    self!.activityIndicator.stopAnimating()
                    
                    let alert = UIAlertController(title: "Failed to geocode location", message: "\(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self!.present(alert, animated: true)
                }
                
                return
            }
            let placemark = placemarks.first
            self!.latitude = placemark?.location?.coordinate.latitude
            self!.longitude = placemark?.location?.coordinate.longitude
            DispatchQueue.main.async {

                print("Lat:: \(String(describing: self!.latitude)), Lon: \(String(describing: self!.longitude))")
            }
            
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.performSegue(withIdentifier: "completeLocationSegue", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "completeLocationSegue" {
            if let postPinViewController = segue.destination as? PostPinViewController {
                postPinViewController.lat = latitude
                postPinViewController.long = longitude
                postPinViewController.location = locationTextField.text
                postPinViewController.firstName = firstNameTextField.text
                postPinViewController.lastName = lastNameTextField.text
                postPinViewController.mediaUrl = linkTextField.text
            }
        }
    }

}
