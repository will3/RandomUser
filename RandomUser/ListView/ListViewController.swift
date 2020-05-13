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

struct RandomUserQuery: Equatable {
    let nextPage: Int?;
    let shouldLoadNextPage: Bool;
}

extension UIScrollView {
    func  isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}

class ListViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!

    let api = RandomUserApi()
    let disposeBag = DisposeBag()
    let loadThreshold = 20.0
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, User>>(
        configureCell: { (_, tableView, indexPath, user: User) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell")! as! ListViewCell
            cell.nameLabel.text = "\(user.name.first) \(user.name.last)"
            cell.ageLabel.text = "\(user.dob.age)"
            cell.locationLabel.text = "In \(user.location.city)"
            let image = URL(string: user.picture.large)
            cell.profileImageView.kf.setImage(with: image)

            return cell
        })
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ListViewCell", bundle: nil), forCellReuseIdentifier: "ListViewCell")
        
        let loadNextPageTrigger: (Driver<ListViewState>) -> Signal<()> =  { state in
            self.tableView.rx.contentOffset.asDriver()
                       .withLatestFrom(state)
                       .flatMap { state in
                        return self.tableView.isNearBottomEdge(edgeOffset: 20.0) && !state.shouldLoadNextPage
                               ? Signal.just(())
                               : Signal.empty()
                       }
               }
        
        let inputFeedbackLoop: (Driver<ListViewState>) -> Signal<ListViewCommand> = { state in
            let loadNextPage = loadNextPageTrigger(state).map { _ in ListViewCommand.loadNextPage }
            return loadNextPage
        }
        
        let searchPerformerFeedback: (Driver<ListViewState>) -> Signal<ListViewCommand> = react(
            request: { (state) in
                RandomUserQuery(nextPage: state.nextPage, shouldLoadNextPage: state.shouldLoadNextPage)
            })
            { (query) -> Signal<ListViewCommand> in
                if !query.shouldLoadNextPage {
                    return Signal.empty()
                }
                
                guard let nextPage = query.nextPage else {
                    return Signal.empty()
                }
                
                return self.api
                    .getUsers(take: 10, page: nextPage)
                    .asSignal(onErrorJustReturn: .failure(RandomUserApiError.networkError))
                    .map(ListViewCommand.responseReceived)
            }
        
        let state = Driver.system(
            initialState: ListViewState.initial,
            reduce: ListViewState.reduce,
            feedback: searchPerformerFeedback, inputFeedbackLoop)
        
        state
            .map { $0.results }
            .map { [SectionModel(model: "Results", items: $0)] }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
