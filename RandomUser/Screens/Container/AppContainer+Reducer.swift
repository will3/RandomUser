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
    var filter = Filter(gender: .both)
    var profiles = [User]()
    var profileIndex = 0
    var refreshing = false
    var showFilterTrigger = false

    static let initial = AppContainer()

    mutating func refresh() {
        profiles = [User]()
        page = 1
        loadMoreTrigger = true
        refreshing = true
    }
}

extension AppContainer {
    static func reduce(state: AppContainer, event: Event) -> AppContainer {
        switch event {
        case let .scrollToPage(scrollViewPage):
            return state.mutate {
                $0.scrollViewPage = scrollViewPage
            }
        case .loadMore:
            return state.mutate {
                $0.loadMoreTrigger = true
            }
        case let .loadMoreSucceeded(response):
            switch response {
            case let .success(results, nextPage):
                return state.mutate {
                    $0.profiles += results
                    $0.page = nextPage
                    $0.loadMoreTrigger = false
                    $0.refreshing = false
                }
            case .failure:
                // TODO: triggstateer error modal
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
        case let .changeFilter(filterChange):
            switch filterChange {
            case let .changeGender(gender):
                return state.mutate {
                    $0.filter.gender = gender.next()
                    $0.refresh()
                }
            case let .changeCountry(code):
                return state.mutate {
                    $0.filter.countryCode = code?.next() ?? .AU
                    $0.refresh()
                }
            case let .changeKitten(kitten):
                return state.mutate {
                    $0.filter.kitten = !kitten
                    $0.refresh()
                }
            }
        case .showFilter:
            return state.mutate {
                $0.showFilterTrigger = true
            }
        case .filterDismissed:
            return state.mutate {
                $0.showFilterTrigger = false
            }
        }
    }
}
