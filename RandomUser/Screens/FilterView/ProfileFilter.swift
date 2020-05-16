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
