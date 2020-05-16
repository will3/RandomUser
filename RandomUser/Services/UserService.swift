//
//  UserService.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import RxSwift

typealias GetUsersResponse = Result<(results: [User], nextPage: Int?), GetUsersError>

enum GetUsersError: Error {
    case apiError(RandomUserApiError)
    case networkError
}

protocol UserService {
    func getUsers(take: Int, page: Int, gender: Gender, countryCode: CountryCode?, kitten: Bool) -> Observable<GetUsersResponse>
}
