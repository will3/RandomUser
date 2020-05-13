//
//  RandomUserApi.swift
//  RandomUser
//
//  Created by will on 13/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

enum RandomUserApiError : Error {
    case malformedJson
}

typealias RandomUserApiResponse = Result<(results: [RUUser], nextPage: Int?), RandomUserApiError>

class RandomUserApi {
    let seed = 1337
    
    let backgroundWorkScheduler: OperationQueueScheduler

    init() {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 2
        operationQueue.qualityOfService = QualityOfService.userInitiated
        backgroundWorkScheduler = OperationQueueScheduler(operationQueue: operationQueue)
    }

    func getUsers(take: Int = 10, page: Int = 1) -> Observable<RandomUserApiResponse> {

        var components = URLComponents(string: "https://randomuser.me/api")!
        components.queryItems = [
            URLQueryItem(name: "seed", value: "\(seed)"),
            URLQueryItem(name: "results", value: "\(take)"),
            URLQueryItem(name: "page", value: "\(page)")]
        let url = components.url!

        return URLSession.shared.rx
            .response(request: URLRequest(url: url))
            .retry(3)
            .observeOn(backgroundWorkScheduler)
            .map { (r, data) -> RandomUserApiResponse in
                guard let welcome = try? JSONDecoder().decode(RUWelcome.self, from: data) else {
                    return .failure(.malformedJson)
                }
                return .success((results: welcome.results, nextPage: welcome.info.page + 1))
            }
    }
}
