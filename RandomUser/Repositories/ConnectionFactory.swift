//
//  IDbConnectionFactory.swift
//  RandomUser
//
//  Created by will on 16/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import SQLite

protocol ConnectionFactory {
    func create() throws -> Connection
}
