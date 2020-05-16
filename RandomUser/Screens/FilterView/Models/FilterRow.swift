//
//  FilterRow.swift
//  RandomUser
//
//  Created by will on 16/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation

enum FilterRow {
    case gender(Gender)
    case country(CountryCode?)
    case kitten(Bool)
}
