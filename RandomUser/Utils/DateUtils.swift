//
//  DateUtils.swift
//  RandomUser
//
//  Created by will on 14/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation

class DateUtils {
    static let calendar = Calendar.current

    static var isoDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }()

    static func calcAge(birthday: Date) -> Int {
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        return ageComponents.year!
    }
}
