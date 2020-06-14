//
//  LoginResponse.swift
//  On The Map
//
//  Created by Jason Yu on 6/14/20.
//  Copyright © 2020 Jason Yu. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let account: AccountResponse
    let session: SessionResponse
}

struct AccountResponse: Codable {
    let registered: Bool
    let key: String
}

struct SessionResponse: Codable {
    let id: String
    let expiration: String
}
