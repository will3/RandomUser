//
//  RandomUserApi.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import RxSwift

enum RandomUserApiError: Error {
    case malformedJson
}

typealias RandomUserApiResponse = Result<(results: [RUUser], nextPage: Int?), RandomUserApiError>

protocol RandomUserApi {
    func getUsers(take: Int, page: Int, gender: String?, countryCode: String?) -> Observable<RandomUserApiResponse>
}
