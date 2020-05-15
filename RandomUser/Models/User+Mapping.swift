//
//  User+Mapping.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation

extension User {
    static func from(user: RUUser) -> User {
        let location = user.location
        let street = "\(location.street.number) \(location.street.name)"
        let address = "\(street), \(location.city), \(location.state), \(location.country)"

        return User(
            username: user.login.username,
            title: user.name.title,
            gender: user.gender,
            firstName: user.name.first,
            lastName: user.name.last,
            dob: DateUtils.isoDateFormatter.date(from: user.dob.date)!,
            thumbImageUrl: user.picture.large,
            address: address,
            largeImageUrl: user.picture.large,
            email: user.email,
            registered: DateUtils.isoDateFormatter.date(from: user.registered.date)!,
            phone: user.phone,
            cell: user.cell,
            nat: user.nat
        )
    }
}
