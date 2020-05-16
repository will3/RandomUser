//
//  Gender.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation

enum Gender {
    case male
    case female
    case both
}

extension Gender {
    func next() -> Gender {
        switch self {
        case .male:
            return .female
        case .female:
            return .both
        case .both:
            return .male
        }
    }
}

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

extension Gender {
    func formatQuery() -> String? {
        switch self {
        case .male:
            return "male"
        case .female:
            return "female"
        case .both:
            return nil
        }
    }
}
