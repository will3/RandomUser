//
//  ProfileFilter+System.swift
//  RandomUser
//
//  Created by will on 16/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import RxFeedback
import RxSwift
import RxCocoa

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
