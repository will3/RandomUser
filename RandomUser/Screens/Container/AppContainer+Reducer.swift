//
//  ContainerView.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation

struct AppContainer: Mutable {
    var scrollViewPage: Int = 0
    var page: Int? = 1
    var loadMoreTrigger = true
    var filter = Filter(gender: .female)
    var profiles = [User]()
    var profileIndex = 0
    var refreshing = false

    static let initial = AppContainer()
    
    mutating func refresh() {
        self.profiles = [User]()
        self.page = 1
        self.loadMoreTrigger = true
        self.refreshing = true
    }
}

extension AppContainer {
    static func reduce(state: AppContainer, event: Event) -> AppContainer {
        switch event {
        case .scrollToPage(let scrollViewPage):
            return state.mutate {
                $0.scrollViewPage = scrollViewPage
            }
        case .loadMore:
            return state.mutate {
                $0.loadMoreTrigger = true
            }
        case .loadMoreSucceeded(let response):
            switch response {
            case let .success(results, nextPage):
                return state.mutate {
                    $0.profiles += results
                    $0.page = nextPage
                    $0.loadMoreTrigger = false
                    $0.refreshing = false
                }
            case .failure(_):
                // TODO triggstateer error modal
                return state.mutate {
                    $0.loadMoreTrigger = false
                    $0.refreshing = false
                }
            }
        case let .navigateToProfile(index: index):
            return state.mutate {
                $0.scrollViewPage = 1
                $0.profileIndex = index
            }
        case .refresh:
            return state.mutate {
                $0.refresh()
            }
        case let .changeFilter(filter):
            return state.mutate {
                $0.filter = filter
                $0.refresh()
            }
        }
    }
}
