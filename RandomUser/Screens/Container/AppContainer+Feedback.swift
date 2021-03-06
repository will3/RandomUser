//
//  AppContainer+Feedback.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import RxCocoa
import RxFeedback
import RxSwift

extension AppContainer {
    typealias Feedback = (Driver<AppContainer>) -> Signal<Event>

    static func system(ui: @escaping Feedback,
                       scrollToPage: @escaping (Int) -> Void,
                       loadProfiles: @escaping (Int, Int, Filter) -> Observable<GetUsersResponse>,
                       showFilter: @escaping () -> ProfileFilterViewController) -> Driver<AppContainer> {
        let scrollToPageFeedback: Feedback = react(request: { $0.changePageQuery }) {
            query in
            scrollToPage(query.page)
            return Signal.empty()
        }

        let loadMore: Feedback = react(request: { $0.loadMoreQuery }) {
            query -> Signal<Event> in
            guard let page = query.page else { return .empty() }
            if !query.loadMoreTrigger { return .empty() }

            return loadProfiles(10, page, query.filter)
                .asSignal(onErrorJustReturn: .failure(.networkError))
                .map(Event.loadMoreSucceeded)
        }

        let showFilter: Feedback = react(request: { $0.showFilterQuery }) {
            query -> Signal<Event> in
            if !query.showFilterTrigger { return Signal.empty() }
            let filterVc = showFilter()
            return filterVc.rx.viewWillDisappear.asSignal().map { _ in Event.filterDismissed }
        }

        return Driver
            .system(
                initialState: AppContainer.initial,
                reduce: AppContainer.reduce(state:event:),
                feedback: ui, scrollToPageFeedback, loadMore, showFilter
            )
    }
}
