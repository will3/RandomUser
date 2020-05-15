//
//  AppContainer+Query.swift
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

    struct ShowFilterQuery: Equatable {
        let showFilterTrigger: Bool
    }
}

extension AppContainer {
    var changePageQuery: ChangePageQuery {
        ChangePageQuery(page: scrollViewPage)
    }

    var loadMoreQuery: LoadMoreQuery {
        LoadMoreQuery(loadMoreTrigger: loadMoreTrigger, page: page, filter: filter)
    }

    var showFilterQuery: ShowFilterQuery {
        ShowFilterQuery(showFilterTrigger: showFilterTrigger)
    }
}
