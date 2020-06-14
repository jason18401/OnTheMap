//
//  SessionRequest.swift
//  On The Map
//
//  Created by Jason Yu on 6/14/20.
//  Copyright © 2020 Jason Yu. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: UdacityLogin
}

struct UdacityLogin: Codable {
    let username: String
    let password: String
}
