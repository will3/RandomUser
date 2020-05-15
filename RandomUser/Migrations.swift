//
//  Migration.swift
//  RandomUser
//
//  Created by will on 14/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import SQLite

class Migrations {
    let connectionFactory: ConnectionFactory

    init(connectionFactory: ConnectionFactory) {
        self.connectionFactory = connectionFactory
    }

    func run() throws {
        let db = try connectionFactory.create()
        if db.userVersion == 0 {
            let users = Table("users")

            let username = Expression<String>("username")
            let gender = Expression<String>("gender")
            let title = Expression<String>("title")
            let firstName = Expression<String>("firstName")
            let lastName = Expression<String>("lastName")
            let dob = Expression<Date>("dob")
            let thumbImageUrl = Expression<Date>("thumbImageUrl")

            try db.run(users.create { t in
                t.column(username, primaryKey: true)
                t.column(gender)
                t.column(title)
                t.column(firstName)
                t.column(lastName)
                t.column(dob)
                t.column(thumbImageUrl)
            })

            db.userVersion = 1
        }

        if db.userVersion == 1 {
            let users = Table("users")
            let address = Expression<String>("address")
            try db.run(users.addColumn(address, defaultValue: ""))
            db.userVersion = 2
        }
        
        if db.userVersion == 2 {
            let users = Table("users")
            let largeImageUrl = Expression<String>("largeImageUrl")
            let email = Expression<String>("email")
            let registered = Expression<Date>("registered")
            let phone = Expression<String>("phone")
            let cell = Expression<String>("cell")
            let nat = Expression<String>("nat")
            let identifier = Expression<String>("identifier")
            try db.run(users.addColumn(largeImageUrl, defaultValue: ""))
            try db.run(users.addColumn(email, defaultValue: ""))
            try db.run(users.addColumn(registered, defaultValue: Date(timeIntervalSince1970: 0)))
            try db.run(users.addColumn(phone, defaultValue: ""))
            try db.run(users.addColumn(cell, defaultValue: ""))
            try db.run(users.addColumn(nat, defaultValue: ""))
            try db.run(users.addColumn(identifier, defaultValue: ""))
            db.userVersion = 3
        }
    }
}

extension Connection {
    public var userVersion: Int32 {
        get { return Int32(try! scalar("PRAGMA user_version") as! Int64) }
        set { try! run("PRAGMA user_version = \(newValue)") }
    }
}
