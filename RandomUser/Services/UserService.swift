//
//  UserService.swift
//  RandomUser
//
//  Created by will on 14/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import Reachability
import RxCocoa
import RxSwift

typealias GetUsersResponse = Result<(results: [User], nextPage: Int?), GetUsersError>

enum GetUsersError: Error {
    case apiError(RandomUserApiError)
    case networkError
}

class UserService {
    let api = RandomUserApi()
    let repository = UserRepository()
    let reachability = try! Reachability()
    let connectionFactory = ConnectionFactory()
    func getUsers(take: Int = 10, page: Int = 1, gender: Gender) -> Observable<GetUsersResponse> {
        let db = try! connectionFactory.create()
        if reachability.connection == .unavailable {
            let count = (try? repository.countUsers(db: db)) ?? 0
            if take * (page - 1) >= count {
                return Observable.just(.success(([User](), nil)))
            }

            let users = (try? repository.getUsers(
                db: db,
                limit: take,
                offset: take * (page - 1),
                gender: gender.formatQuery()
            ))
                ?? [User]()
            return Observable.just(.success((users, page + 1)))
        }

        return api
            .getUsers(take: take, page: page, gender: gender.formatQuery())
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

extension Gender {
    func formatQuery() -> String? {
        switch self {
        case .male:
            return "male"
        case .female:
            return "female"
        case .both:
            return nil
        }
    }
}
