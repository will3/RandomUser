//
//  ViewController.swift
//  RandomUser
//
//  Created by will on 13/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Alamofire
import Kingfisher
import RxCocoa
import RxDataSources
import RxFeedback
import RxSwift
import SnapKit
import UIKit

class PersonListViewController: UIViewController, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!

    var usersState: NestedSystem<[User]>?
    
    let refreshControl = UIRefreshControl()

    lazy var filterButton = {
        Bundle.main.loadNibNamed("FilterFab", owner: nil, options: nil)![0] as! FilterFab
    }()

    private let disposeBag = DisposeBag()
    private let loadThreshold = 20.0
    private let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, User>>(
        configureCell: { (_, tableView, _, user: User) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonListViewCell")! as! PersonListViewCell
            cell.configureUser(user)

            return cell
        })

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.addSubview(refreshControl)
        tableView.register(UINib(nibName: "PersonListViewCell", bundle: nil), forCellReuseIdentifier: "PersonListViewCell")

        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        view.addSubview(filterButton)
        filterButton.snp.makeConstraints { make in
            make.right.equalTo(view.snp.right).offset(-24)
            make.bottom.equalTo(view.snp.bottom).offset(-24)
        }

        let bindUI: (Driver<PersonList>) -> Signal<PersonList.Event> = bind(self) { me, state in
            let subscriptions = [
                state
                    .map { $0.results }
                    .map { [SectionModel(model: "Results", items: $0)] }
                    .drive(me.tableView.rx.items(dataSource: me.dataSource)),
            ]

            var events: [Signal<PersonList.Event>] = [
            ]

            if let usersState = me.usersState {
                events += [
                    usersState.asSignal(onErrorSignalWith: .empty()).map(PersonList.Event.profilesUpdated),
                ]
            }

            return Bindings(subscriptions: subscriptions, events: events)
        }

        PersonList.feedback(
            initialState: PersonList.initial,
            ui: bindUI
        )
        .drive()
        .disposed(by: disposeBag)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
