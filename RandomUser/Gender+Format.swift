//
//  Gender+Format.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation

extension Gender {
    func format() -> String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        case .both:
            return "Both"
        }
    }
}
