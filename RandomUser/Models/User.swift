//
//  User.swift
//  RandomUser
//
//  Created by will on 14/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation

struct User : Encodable, Decodable {
    let username: String
    let title: String
    let gender: String
    let firstName: String
    let lastName: String
    let dob: Date
    let thumbImageUrl: String
    let address: String?
}
