//
//  User.swift
//  On The Map
//
//  Created by Jason Yu on 6/10/20.
//  Copyright © 2020 Jason Yu. All rights reserved.
//

import Foundation

struct UserResponse: Codable {
    let results: [User]
}

struct User: Codable {
    let firstName: String
    let lastName: String
    let mediaURL: String
    let longitude: Double
    let latitude:  Double
}
