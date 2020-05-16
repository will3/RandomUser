//
//  ProfileGallery+Feedback.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import RxCocoa
import RxFeedback
import RxSwift

extension ProfileGallery {
    typealias Feedback = (Driver<ProfileGallery>) -> Signal<ProfileGallery.Event>

    static func feedback(ui: @escaping Feedback) -> Driver<ProfileGallery> {
        return Driver
            .system(
                initialState: ProfileGallery.initial,
                reduce: ProfileGallery.reduce,
                feedback: ui
            )
    }
}
