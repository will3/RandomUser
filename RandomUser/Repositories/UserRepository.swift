//
//  UserRepository.swift
//  RandomUser
//
//  Created by will on 14/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import SQLite

class ConnectionFactory {
    func create() throws -> Connection {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!

        return try Connection("\(path)/db.sqlite3")
    }
}

class UserRepository {
    private let queue = DispatchQueue(label: "will.company.RandomUser.UserRepository.queue")

    func saveUsers(db: Connection, items: [User]) throws {
        let users = Table("users")
        let id = Expression<String>("id")

        for item in items {
            queue.async {
                do {
                    if try db.scalar(users.filter(id == item.id).count) > 0 {
                        try db.run(users.filter(id == item.id).update(item))
                    } else {
                        try db.run(users.insert(item))
                    }
                } catch {
                    print("Unexpected error: \(error).")
                }
            }
        }
    }
    
    func countUsers(db: Connection) throws -> Int {
        let users = Table("users")
        return try db.scalar(users.count)
    }

    func getUsers(db: Connection, limit: Int, offset: Int) throws -> [User] {
        let users = Table("users")
        let query = users
            .limit(limit, offset: offset)
        let rows = try db.prepare(query)
            
        return try rows.map({ (row) -> User in
            return try row.decode()
        })
    }
}
