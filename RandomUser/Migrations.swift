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
    static func run() throws {
        let db = try ConnectionFactory().create()
        if db.userVersion == 0 {
            let users = Table("users")
            
            let id = Expression<String>("id")
            let gender = Expression<String>("gender")
            let title = Expression<String>("title")
            let firstName = Expression<String>("firstName")
            let lastName = Expression<String>("lastName")
            let dob = Expression<Date>("dob")
            let thumbImageUrl = Expression<Date>("thumbImageUrl")
            
            try db.run(users.create { t in
                t.column(id, primaryKey: true)
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
    }
}

extension Connection {
    public var userVersion: Int32 {
        get { return Int32(try! scalar("PRAGMA user_version") as! Int64)}
        set { try! run("PRAGMA user_version = \(newValue)") }
    }
}
