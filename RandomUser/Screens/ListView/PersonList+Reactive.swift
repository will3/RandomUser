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
    var tapProfile: Signal<(Int)> {
        let tableView = self.base.tableView!
        return tableView.rx.itemSelected.asSignal().map { $0.item }
    }

    var tapFilter: Signal<()> {
        let filterButton = self.base.filterButton
        return filterButton.button.rx.controlEvent(.touchUpInside).asSignal()
    }
    
    var nearBottom: Signal<()> {
        let tableView = self.base.tableView!
        return tableView.rx.contentOffset.asDriver().flatMap { _ in
            tableView.isNearBottomEdge() ? Signal.just(()) : Signal.empty()
        }
    }
}
