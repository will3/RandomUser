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

class UserServiceImpl: UserService {
    private let api: RandomUserApi
    private let repository: UserRepository
    private let networkStatus: NetworkStatus
    private let connectionFactory: ConnectionFactory

    init(repository: UserRepository, networkStatus: NetworkStatus, connectionFactory: ConnectionFactory, api: RandomUserApi) {
        self.repository = repository
        self.networkStatus = networkStatus
        self.connectionFactory = connectionFactory
        self.api = api
    }

    func getUsers(take: Int, page: Int, gender: Gender, countryCode: CountryCode?, kitten: Bool) -> Observable<GetUsersResponse> {
        let response = getUsers(take: take, page: page, gender: gender, countryCode: countryCode)
        if !kitten {
            return response
        }
        return response.map {
            r in
            switch (r) {
            case let .success((results, nextPage)):
                return .success((results.enumerated().map { (index, user) in
                    user.mutate {
                        $0.thumbImageUrl = "https://placekitten.com/200/200?image=\(index % 16)"
                        $0.largeImageUrl = "https://placekitten.com/700/700?image=\(index % 16)"
                    }
                }, nextPage))
            default:
                return r
            }
        }
    }

    private func getUsers(take: Int, page: Int, gender: Gender, countryCode: CountryCode?) -> Observable<GetUsersResponse> {
        let db = try! connectionFactory.create()
        
        if networkStatus.isDisconnected {
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
