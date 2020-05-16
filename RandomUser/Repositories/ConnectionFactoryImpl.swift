//
//  DbConnectionFactory.swift
//  RandomUser
//
//  Created by will on 16/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import SQLite

class ConnectionFactoryImpl: ConnectionFactory {
    let filename: String

    init(filename: String) {
        self.filename = filename
    }

    func create() throws -> Connection {
        return try Connection(filename)
    }
}
