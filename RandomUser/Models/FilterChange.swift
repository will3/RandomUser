//
//  FilterChange.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation

enum FilterChange {
    case changeGender(Gender)
    case changeCountry(CountryCode?)
    case changeKitten(Bool)
}
