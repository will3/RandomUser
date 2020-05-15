//
//  AppContainer+Event.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation

extension AppContainer {
    enum Event {
        case scrollToPage(Int)
        case loadMore
        case loadMoreSucceeded(GetUsersResponse)
        case navigateToProfile(index: Int)
        case refresh
        case changeFilter(Filter)
    }
}
