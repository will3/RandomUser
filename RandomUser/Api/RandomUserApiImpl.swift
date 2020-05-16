//
//  RandomUserApi.swift
//  RandomUser
//
//  Created by will on 13/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift

class RandomUserApiImpl: RandomUserApi {
    let seed: Int
    let baseURL: String

    init(baseURL: String, seed: Int) {
        self.baseURL = baseURL
        self.seed = seed
    }

    func getUsers(take: Int = 10, page: Int = 1, gender: String?, countryCode: String?) -> Observable<RandomUserApiResponse> {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            // Seed does not support filters
            // URLQueryItem(name: "seed", value: "\(seed)"),
            URLQueryItem(name: "results", value: "\(take)"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "gender", value: gender),
            URLQueryItem(name: "nat", value: countryCode),
        ]
        let url = components.url!

        return URLSession.shared.rx
            .response(request: URLRequest(url: url))
            .retry(3)
            .observeOn(MainScheduler.instance)
            .map { (_, data) -> RandomUserApiResponse in
                guard let welcome = try? JSONDecoder().decode(RUWelcome.self, from: data) else {
                    return .failure(.malformedJson)
                }
                return .success((results: welcome.results, nextPage: welcome.info.page + 1))
            }
    }
}
