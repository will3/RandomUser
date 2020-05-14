//
//  ViewController.swift
//  RandomUser
//
//  Created by will on 13/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import Kingfisher
import RxCocoa
import RxFeedback
import RxDataSources
import SnapKit

extension UIScrollView {
    func  isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}

class ListViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    let refreshControl = UIRefreshControl()

    let userService = UserService()
    let disposeBag = DisposeBag()
    let loadThreshold = 20.0
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, User>>(
        configureCell: { (_, tableView, indexPath, user: User) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell")! as! ListViewCell
            cell.nameLabel.text = user.formatName()
            let age = DateUtils.calcAge(birthday: user.dob)
            cell.ageLabel.text = "\(age)"
            let image = URL(string: user.thumbImageUrl)
            cell.profileImageView.kf.setImage(with: image)
            cell.locationLabel.text = user.address

            return cell
        })
    
    lazy var filterButton = {
        Bundle.main.loadNibNamed("FilterFab", owner: nil, options: nil)![0] as! FilterFab
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.addSubview(refreshControl)
        tableView.register(UINib(nibName: "ListViewCell", bundle: nil), forCellReuseIdentifier: "ListViewCell")

        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        view.addSubview(filterButton)
        filterButton.snp.makeConstraints { (make) in
            make.right.equalTo(view.snp.right).offset(-24)
            make.bottom.equalTo(view.snp.bottom).offset(-24)
        }

        let loadUsers: (Driver<ListViewState>) -> Signal<ListViewCommand> = react(
            request: { $0.getUsersQuery })
            { (query) -> Signal<ListViewCommand> in
                if !query.shouldLoadNextPage { return Signal.empty() }
                guard let nextPage = query.nextPage else { return Signal.empty() }

                return self.userService
                    .getUsers(take: 10, page: nextPage, gender: query.gender)
                    .asSignal(onErrorJustReturn: .failure(.networkError))
                    .map(ListViewCommand.responseReceived)
            }
        
        let openProfileView: (Driver<ListViewState>) -> Signal<ListViewCommand> = react(
            request: { OpenProfileQuery(
                index: $0.selectedIndex,
                profiles: $0.results,
                openProfileCount: $0.openProfileCount,
                nextPage: $0.nextPage) })
            { (query) -> Signal<ListViewCommand> in
                guard let index = query.index else { return Signal.empty() }
                return ProfileViewController
                    .prompt(from: self, index: index, profiles: query.profiles, nextPage: query.nextPage)
                    .flatMapLatest { vc -> Observable<ListViewCommand> in
                        return Observable.just(ListViewCommand.closedProfileView)
                    }
                    .asSignal(onErrorSignalWith: Signal.empty())
            }

        let bindUI: (Driver<ListViewState>) -> Signal<ListViewCommand> = bind(self) { me, state in
            let subscriptions = [
                state
                    .map { $0.results }
                    .map { [SectionModel(model: "Results", items: $0)] }
                    .drive(me.tableView.rx.items(dataSource: me.dataSource)),
                state
                    .map { $0.refreshing }
                    .drive(me.refreshControl.rx.isRefreshing)
            ]

            let loadNextPage: Signal<ListViewCommand> = me.tableView.rx.contentOffset.asDriver()
                .flatMap { _ in
                    return me.tableView.isNearBottomEdge(edgeOffset: 20.0)
                    ? Signal.just(())
                        : Signal.empty() }
                .map { _ in ListViewCommand.loadNextPage }

            let pullToRefresh = me.refreshControl.rx
                .controlEvent(.valueChanged)
                .asSignal()
                .map { _ in ListViewCommand.refresh }

            let changeFilter = me.filterButton.button.rx.controlEvent(.touchUpInside)
                .asSignal()
                .withLatestFrom(state)
                .flatMapLatest {
                    state in FilterViewController.prompt(from: me, filter: state.filter)
                    .flatMapLatest { fv -> Observable<ListViewCommand> in
                        guard let fv = fv, let filter = fv.filter.value else {
                            return Observable.empty()
                        }
                        if !fv.filterChanged {
                            return Observable.empty()
                        }
                        return Observable.just(ListViewCommand.changeFilter(filter))
                    }
                    .asSignal(onErrorSignalWith: Signal.empty())
                }
            
            let tapOnProfile = me.tableView.rx
                .itemSelected
                .asSignal()
                .map { ListViewCommand.openProfile($0.item) }

            let events: [Signal<ListViewCommand>] = [
                loadNextPage,
                pullToRefresh,
                changeFilter,
                tapOnProfile
            ]

            return Bindings(subscriptions: subscriptions, events: events)
        }

        Driver.system(
            initialState: ListViewState.initial,
            reduce: ListViewState.reduce,
            feedback: bindUI, loadUsers, openProfileView)
            .drive()
            .disposed(by: disposeBag)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
