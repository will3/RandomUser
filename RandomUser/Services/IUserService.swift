//
//  IUserService.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import RxSwift

protocol IUserService {
    func getUsers(take: Int, page: Int, gender: Gender, countryCode: CountryCode?) -> Observable<GetUsersResponse>
}
