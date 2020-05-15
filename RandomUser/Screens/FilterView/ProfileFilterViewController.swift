//
//  ProfileFilterViewController.swift
//  RandomUser
//
//  Created by will on 14/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import RxCocoa
import RxDataSources
import RxFeedback
import RxSwift
import RxViewController
import UIKit

enum FilterRow {
    case gender(Gender)
    case country(CountryCode?)
    case kitten(Bool)
}

class ProfileFilterViewController: UIViewController, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var doneButton: UIBarButtonItem!

    var filterState: NestedSystem<Filter>?

    let disposeBag = DisposeBag()

    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, FilterRow>>(
        configureCell: { (_, tableView, _, row: FilterRow) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell")! as! FilterCell

            cell.configure(row: row)

            return cell
        })

    override func viewDidLoad() {
        doneButton.accessibilityIdentifier = AccessibilityIdentifiers.doneButton

        tableView.register(UINib(nibName: "FilterCell", bundle: nil), forCellReuseIdentifier: "FilterCell")

        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        let bindUI: ProfileFilter.Feedback = bind(self) { me, _ in
            var subscriptions: [Disposable] = []

            if let filterState = me.filterState {
                subscriptions += [
                    filterState.map { filter in
                        [
                            FilterRow.gender(filter.gender),
                            FilterRow.country(filter.countryCode),
                            FilterRow.kitten(filter.kitten)
                        ]
                    }
                    .map { [SectionModel(model: "Results", items: $0)] }
                    .asDriver(onErrorJustReturn: [])
                    .drive(me.tableView.rx.items(dataSource: me.dataSource)),
                ]
            }

            let events: [Signal<ProfileFilter.Event>] = [
                me.doneButton.rx.tap.asSignal().map { _ in ProfileFilter.Event.dismissView },
            ]

            return Bindings(subscriptions: subscriptions, events: events)
        }

        ProfileFilter
            .system(ui: bindUI, dismissView: dismissView)
            .drive()
            .disposed(by: disposeBag)
    }

    private func dismissView() {
        dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
