//
//  ProfileFilter.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import RxCocoa
import RxFeedback
import RxSwift

struct ProfileFilter {
    var dismissViewTrigger: Int = 0

    static let initial = ProfileFilter()
}

extension ProfileFilter: Mutable {}

struct DismissViewQuery: Equatable {
    let dismissViewTrigger: Int
}

extension ProfileFilter {
    var dismissViewQuery: DismissViewQuery {
        return DismissViewQuery(dismissViewTrigger: dismissViewTrigger)
    }
}

extension ProfileFilter {
    enum Event {
        case dismissView
    }
}

extension ProfileFilter {
    static func reduce(state: ProfileFilter, event: ProfileFilter.Event) -> ProfileFilter {
        switch event {
        case .dismissView:
            return state.mutate {
                $0.dismissViewTrigger += 1
            }
        }
    }
}

extension ProfileFilter {
    typealias Feedback = (Driver<ProfileFilter>) -> Signal<ProfileFilter.Event>

    static func system(
        ui: @escaping Feedback,
        dismissView: @escaping () -> Void
    ) -> Driver<ProfileFilter> {
        let dismiss: Feedback = react(
            request: { $0.dismissViewQuery })
        { _ -> Signal<Event> in
            dismissView()
            return Signal.empty()
        }

        return Driver.system(
            initialState: ProfileFilter.initial,
            reduce: ProfileFilter.reduce(state:event:),
            feedback: ui, dismiss
        )
    }
}
