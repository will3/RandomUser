//
//  CountryCode.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation

enum CountryCode {
    case AU, BR, CA, CH, DE, DK, ES, FI, FR, GB, IE, IR, NO, NL, NZ, TR, US
}

extension CountryCode {
    func next() -> CountryCode? {
        let inOrder: [CountryCode] = [.AU, .BR, .CA, .CH, .DE, .DK, .ES, .FI, .FR, .GB, .IE, .IR, .NO, .NL, .NZ, .TR, .US]
        guard let index = inOrder.firstIndex(of: self) else {
            return nil
        }

        if index + 1 >= inOrder.count {
            return nil
        }

        return inOrder[index + 1]
    }
}

extension CountryCode {
    func formatShort() -> String {
        switch self {
        case .AU:
            return "au"
        case .BR:
            return "br"
        case .CA:
            return "ca"
        case .CH:
            return "ch"
        case .DE:
            return "de"
        case .DK:
            return "dk"
        case .ES:
            return "es"
        case .FI:
            return "fi"
        case .FR:
            return "fr"
        case .GB:
            return "gb"
        case .IE:
            return "ie"
        case .IR:
            return "ir"
        case .NO:
            return "no"
        case .NL:
            return "nl"
        case .NZ:
            return "nz"
        case .TR:
            return "tr"
        case .US:
            return "us"
        }
    }
}

extension CountryCode {
    func formatName() -> String {
        switch self {
        case .AU:
            return "Australia"
        case .BR:
            return "Brazil"
        case .CA:
            return "Canada"
        case .CH:
            return "Switzerland"
        case .DE:
            return "Germany"
        case .DK:
            return "Denmark"
        case .ES:
            return "Spain"
        case .FI:
            return "Finland"
        case .FR:
            return "France"
        case .GB:
            return "United Kingdom"
        case .IE:
            return "Ireland"
        case .IR:
            return "Iran"
        case .NO:
            return "Norway"
        case .NL:
            return "Netherlands"
        case .NZ:
            return "New Zealand"
        case .TR:
            return "Turkey"
        case .US:
            return "United States"
        }
    }
}
