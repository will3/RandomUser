//
//  PersonList+Event.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation

extension PersonList {
    enum Event {
        case responseReceived([User])
    }
}
