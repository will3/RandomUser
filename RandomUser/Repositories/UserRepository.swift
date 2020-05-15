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
    let filename: String

    init(filename: String) {
        self.filename = filename
    }

    func create() throws -> Connection {
        return try Connection(filename)
    }
}

class UserRepository: IUserRepository {
    private let queue: DispatchQueue

    init(queue: DispatchQueue) {
        self.queue = queue
    }

    func saveUsers(db: Connection, items: [User]) throws {
        let users = Table("users")
        let username = Expression<String>("username")

        for item in items {
            queue.async {
                do {
                    if try db.scalar(users.filter(username == item.username).count) > 0 {
                        try db.run(users.filter(username == item.username).update(item))
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

    func getUsers(db: Connection, limit: Int, offset: Int, gender: String?) throws -> [User] {
        let users = Table("users")
        let genderEx = Expression<String>("gender")

        var query = users

        if let gender = gender {
            query = query.filter(genderEx == gender)
        }

        query = query.limit(limit, offset: offset)

        let rows = try db.prepare(query)

        return try rows.map { (row) -> User in
            try row.decode()
        }
    }
}
