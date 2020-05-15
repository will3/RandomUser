//
//  PersonList+Reactive.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base == PersonListViewController {
    var tapProfile: Signal<Int> {
        let tableView = base.tableView!
        return tableView.rx.itemSelected.asSignal().map { $0.item }
    }

    var tapFilter: Signal<Void> {
        let filterButton = base.filterButton
        return filterButton.button.rx.controlEvent(.touchUpInside).asSignal()
    }

    var nearBottom: Signal<Void> {
        let tableView = base.tableView!
        return tableView.rx.nearBottom
    }
}
