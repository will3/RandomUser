//
//  Filter.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation

struct Filter: Equatable {
    var gender: Gender
    var countryCode: CountryCode?
}

extension Filter: Mutable {}
