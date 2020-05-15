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

class UserService: IUserService {
    let api: IRandomUserApi
    let repository: IUserRepository
    let reachability: Reachability
    let connectionFactory: ConnectionFactory

    init(repository: IUserRepository, reachability: Reachability, connectionFactory: ConnectionFactory, api: IRandomUserApi) {
        self.repository = repository
        self.reachability = reachability
        self.connectionFactory = connectionFactory
        self.api = api
    }

    func getUsers(take: Int = 10, page: Int = 1, gender: Gender, countryCode: CountryCode?, kitten: Bool) -> Observable<GetUsersResponse> {
        let response = getUsers(take: take, page: page, gender: gender, countryCode: countryCode)
        if !kitten {
            return response
        }
        return response.map {
            r in
            switch (r) {
            case let .success((results, nextPage)):
                return .success((results.map { user in
                    user.mutate {
                        $0.thumbImageUrl = "https://placekitten.com/g/200/200"
                        $0.largeImageUrl = "https://placekitten.com/g/800/800"
                    }
                }, nextPage))
            default:
                return r
            }
        }
    }

    func getUsers(take: Int = 10, page: Int = 1, gender: Gender, countryCode: CountryCode?) -> Observable<GetUsersResponse> {
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
            .getUsers(take: take, page: page, gender: gender.formatQuery(), countryCode: countryCode?.formatShort())
            .map { (r) -> GetUsersResponse in
                switch r {
                case let .success(results, nextPage):
                    let users = results.map(User.from)
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
