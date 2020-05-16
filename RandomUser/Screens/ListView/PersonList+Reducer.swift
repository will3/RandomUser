//
//  PersonList+Reducer.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation

extension PersonList: Mutable {}

struct PersonList {
    static let initial = PersonList()
    var results = [User]()
}

extension PersonList {
    static func reduce(state: PersonList, event: PersonList.Event) -> PersonList {
        switch event {
        case let .profilesUpdated(profiles):
            return state.mutate {
                $0.results = profiles
            }
        }
    }
}
