//
//  PersonList+Feedback.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxFeedback

extension PersonList {
    typealias Feedback = (Driver<PersonList>) -> Signal<PersonList.Event>
    
    static func feedback(
        initialState: PersonList,
        ui: @escaping Feedback) -> Driver<PersonList> {
        
        return Driver.system(
            initialState: initialState,
            reduce: PersonList.reduce,
            feedback: ui
        )
    }
}
