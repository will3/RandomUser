//
//  ListViewState.swift
//  RandomUser
//
//  Created by will on 14/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation

enum ListViewCommand {
    case loadNextPage
    case responseReceived(GetUsersResponse)
}

struct ListViewState {
    static let initial = ListViewState()
    var results = [User]()
    var shouldLoadNextPage = true
    var nextPage: Int? = 1
    var failure: GetUsersError?
}

extension ListViewState: Mutable { }

extension ListViewState {
    static func reduce(state: ListViewState, command: ListViewCommand) -> ListViewState {
        switch command {
        case .loadNextPage:
            return state.mutate {
                if $0.failure == nil {
                    $0.shouldLoadNextPage = true
                }
            }
        case .responseReceived(let response):
            switch response {
            case let .success(users, nextPage):
                return state.mutate {
                    $0.results = $0.results + users
                    $0.nextPage = nextPage
                    $0.shouldLoadNextPage = false
                    $0.failure = nil
                }
            case let .failure(error):
                return state.mutate { $0.failure = error }
            }
        }
    }
}
