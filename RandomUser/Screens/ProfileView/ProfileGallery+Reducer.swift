//
//  ProfileGallery.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation

extension ProfileGallery: Mutable {}

struct ProfileGallery {
    var profiles: [User] = [User]()
    var index: Int = 0

    static let initial = ProfileGallery()
}

extension ProfileGallery {
    static func reduce(state: ProfileGallery, event: ProfileGallery.Event) -> ProfileGallery {
        // It's empty for now
        switch event {
        default:
            return state
        }
    }
}
