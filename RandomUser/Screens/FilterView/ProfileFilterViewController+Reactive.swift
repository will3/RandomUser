//
//  ProfileFilterViewController+Reactive.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base == ProfileFilterViewController {
    var filterChanged: Signal<FilterChange> {
        base.tableView.rx.modelSelected(FilterRow.self).asSignal().map { row in
            switch row {
            case let .gender(gender):
                return .changeGender(gender)
            case let .country(code):
                return .changeCountry(code)
            case let .kitten(kitten):
                return .changeKitten(kitten)
            }
        }
    }
}
