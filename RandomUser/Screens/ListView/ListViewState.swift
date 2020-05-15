//
//  ListViewState.swift
//  RandomUser
//
//  Created by will on 14/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation

enum Gender {
    case male
    case female
    case both
}

struct Filter: Equatable {
    var gender: Gender
}

extension Filter: Mutable {}

enum ListViewCommand {
    case loadNextPage
    case responseReceived(GetUsersResponse)
    case refresh
    case presentFilter
    case changeFilter(Filter)
    case openProfile(Int)
}

struct ListViewState {
    static let initial = ListViewState()
    var results = [User]()
    var shouldLoadNextPage = true
    var nextPage: Int? = 1
    var failure: GetUsersError?
    var refreshing = false
    var filter: Filter
    var selectedIndex: Int?
    var openProfileCount = 0

    var getUsersQuery: GetUsersQuery {
        return GetUsersQuery(
            nextPage: nextPage,
            shouldLoadNextPage: shouldLoadNextPage,
            gender: filter.gender
        )
    }

    init() {
        filter = Filter(gender: .female)
    }
}

// TODO: optimize Equatable
struct OpenProfileQuery: Equatable {
    let index: Int?
    let profiles: [User]
    let openProfileCount: Int
    let nextPage: Int?
    let filter: Filter
}

struct GetUsersQuery: Equatable {
    let nextPage: Int?
    let shouldLoadNextPage: Bool
    let gender: Gender
}

extension ListViewState: Mutable {}

extension ListViewState {
    static func reduce(state: ListViewState, command: ListViewCommand) -> ListViewState {
        switch command {
        case .loadNextPage:
            return state.mutate {
                if $0.failure == nil {
                    $0.shouldLoadNextPage = true
                }
            }
        case let .responseReceived(response):
            switch response {
            case let .success(users, nextPage):
                return state.mutate {
                    $0.results = $0.results + users
                    $0.nextPage = nextPage
                    $0.shouldLoadNextPage = false
                    $0.failure = nil
                    $0.refreshing = false
                }
            case let .failure(error):
                return state.mutate { $0.failure = error }
            }
        case .refresh:
            return state.mutate {
                $0.results = [User]()
                $0.nextPage = 1
                $0.shouldLoadNextPage = true
                $0.failure = nil
                $0.refreshing = true
            }
        case let .changeFilter(filter):
            print("change filter \(filter)")
            return state.mutate {
                $0.filter = filter
                $0.results = [User]()
                $0.nextPage = 1
                $0.shouldLoadNextPage = true
                $0.failure = nil
            }
        case let .openProfile(index):
            return state.mutate {
                $0.selectedIndex = index
                $0.openProfileCount = $0.openProfileCount + 1
            }
        default:
            return state
        }
    }
}
