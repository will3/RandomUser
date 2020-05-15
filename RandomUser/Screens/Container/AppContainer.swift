//
//  ContainerView.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation

extension AppContainer {
    struct ChangePageQuery: Equatable {
        let page: Int
    }

    struct LoadMoreQuery: Equatable {
        let loadMoreTrigger: Bool
        let page: Int?
        let filter: Filter
    }
}

struct AppContainer: Mutable {
    var scrollViewPage: Int = 0
    var page: Int? = 1
    var loadMoreTrigger = true
    var filter = Filter(gender: .female)
    var profiles = [User]()

    var changePageQuery: ChangePageQuery {
        return ChangePageQuery(page: scrollViewPage)
    }
    
    var loadMoreQuery: LoadMoreQuery {
        return LoadMoreQuery(loadMoreTrigger: loadMoreTrigger, page: page, filter: filter)
    }

    static let initial = AppContainer()
}

extension AppContainer {
    enum Event {
        case scrollToPage(Int)
        case loadMore
        case loadMoreSucceeded(GetUsersResponse)
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
                }
            case .failure(_):
                // TODO trigger error modal
                return state.mutate {
                    $0.loadMoreTrigger = false
                }
            }
        }
    }
}
