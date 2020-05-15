//
//  IUserRepository.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import SQLite

protocol IUserRepository {
    func saveUsers(db: Connection, items: [User]) throws
    func countUsers(db: Connection) throws -> Int
    func getUsers(db: Connection, limit: Int, offset: Int, gender: String?) throws -> [User]
}
