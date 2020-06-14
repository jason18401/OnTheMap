//
//  LoginViewController.swift
//  On The Map
//
//  Created by Jason Yu on 6/14/20.
//  Copyright © 2020 Jason Yu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dismissKey = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(dismissKey)
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        emailTextField.text = "flieswithmonkeybusiness@yahoo.com"
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        if emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            let alert = UIAlertController(title: "Please enter Email", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            print("HERE1")
            self.present(alert, animated: true)
        } else if passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            let alert = UIAlertController(title: "Please enter Password", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            print("HERE2")
            self.present(alert, animated: true)
        }
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            //post request
            UserAPI.shared.loginRequest(email: email, password: password) { result in
                switch result {
//                case .success(true):
//                    print("YESS::")
                case .success(let response):
                    DispatchQueue.main.async {
                        print("LOGINSUCCESS:: \(response.account.key)")
                        self.performSegue(withIdentifier: "loginSegue", sender: self)
                    }
                case .failure(let response):
                    DispatchQueue.main.async {
                        print("NOO:: \(response)")
                        let alert = UIAlertController(title: "Invalid email or password", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        if let url = URL(string: "https://www.udacity.com") {
            UIApplication.shared.open(url)
        }
        print("SIGNUP:")
    }
    
}
