//
//  User+Format.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation

extension User {
    func formatName() -> String {
        return "\(title) \(firstName) \(lastName)"
    }
}
