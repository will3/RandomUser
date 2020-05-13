//
//  UserService.swift
//  RandomUser
//
//  Created by will on 14/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Reachability

typealias GetUsersResponse = Result<(results: [User], nextPage: Int?), GetUsersError>

enum GetUsersError : Error {
    case apiError(RandomUserApiError)
    case networkError
}

class UserService {
    let api = RandomUserApi()
    let repository = UserRepository()
    let reachability = try! Reachability()
    let connectionFactory = ConnectionFactory()
    func getUsers(take: Int = 10, page: Int = 1) -> Observable<GetUsersResponse> {
        let db = try! self.connectionFactory.create()
        if reachability.connection == .unavailable {
            let count = (try? self.repository.countUsers(db: db)) ?? 0
            if (take * (page - 1) >= count) {
                return Observable.just(.success(([User](), nil)))
            }
            let users = (try? self.repository.getUsers(db: db, limit: take, offset: take * (page - 1)))
                ?? [User]()
            return Observable.just(.success((users, page + 1)))
        }

        return api
            .getUsers(take: take, page: page)
            .map { (r) -> GetUsersResponse in
                switch r {
                case let .success(results, nextPage):
                    let users = results.map(UserMapper.mapUser)
                    try! self.repository.saveUsers(db: db, items: users)
                    return .success((results: users, nextPage: nextPage))
                case let .failure(err):
                    return .failure(.apiError(err))
            }
        }
    }
}
