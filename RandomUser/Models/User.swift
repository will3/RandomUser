//
//  User.swift
//  RandomUser
//
//  Created by will on 14/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation

struct User: Encodable, Decodable, Equatable {
    let username: String
    let title: String
    let gender: String
    let firstName: String
    let lastName: String
    let dob: Date
    var thumbImageUrl: String
    let address: String?

    var largeImageUrl: String?
    let email: String?
    let registered: Date?
    let phone: String?
    let cell: String?
    let nat: String?
}

extension User: Mutable { }
