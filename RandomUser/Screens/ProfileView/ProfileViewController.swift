//
//  ProfileViewController.swift
//  RandomUser
//
//  Created by will on 14/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxFeedback
import RxSwift
import RxViewController

struct LoadProfilesQuery: Equatable {
    let page: Int?
    let filter: Filter
    let loadNextPageTrigger: Bool
}

enum ProfileViewCommand {
    case loadMore
    case loadMoreCompleted(GetUsersResponse)
}

struct ProfileViewState: Mutable {
    var profiles: [User] = [User]()
    var index: Int = 0
    var nextPage: Int? = 0
    var filter: Filter = Filter(gender: .both)
    var failure: GetUsersError?
    var loadNextPageTrigger = false

    var loadProfilesQuery: LoadProfilesQuery {
        return LoadProfilesQuery(page: nextPage, filter: filter, loadNextPageTrigger: loadNextPageTrigger)
    }

    static let initial = ProfileViewState()
}

extension ProfileViewController {
    static func prompt(
        from: UIViewController,
        index: Int,
        profiles: [User],
        nextPage: Int?
        ) -> Observable<ProfileViewController?> {
        return Observable.create { observer in
            let vc = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
            vc.setup(profiles: profiles, index: index, nextPage: nextPage)
            vc.modalPresentationStyle = .fullScreen
            from.present(vc, animated: true, completion: nil)
            
            let dispose = vc.rx.viewWillDisappear.bind { [weak vc] _ in
                observer.on(.next(vc))
                observer.onCompleted()
            }
            
            return dispose
        }
    }
}

class ProfileViewController: UIViewController {
    var initial = ProfileViewState.initial
    let disposeBag = DisposeBag()
    let userService = UserService()
    let swipeView = ProfileSwipeView()
    
    func setup(profiles: [User], index: Int, nextPage: Int?) {
        initial = initial.mutate {
            $0.profiles = profiles
            $0.index = index
            $0.nextPage = nextPage
        }
    }

    override func viewDidLoad() {
        self.view.addSubview(swipeView)
        swipeView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }

        let bindUI: (Driver<ProfileViewState>) -> Signal<ProfileViewCommand> = bind(self) { me, state in
            let subscriptions: [Disposable] = [
                state.map { $0.profiles }.distinctUntilChanged().drive(me.swipeView.rx.profiles),
                state.map { $0.index }.distinctUntilChanged().drive(me.swipeView.rx.startIndex)
            ]
            let events: [Signal<ProfileViewCommand>] = [
                me.swipeView.rx.loadMore.asSignal(onErrorJustReturn: me.swipeView)
                    .map { _ in ProfileViewCommand.loadMore }
            ]

            return Bindings(subscriptions: subscriptions, events: events)
        }

        let loadMore: (Driver<ProfileViewState>) -> Signal<ProfileViewCommand> = react(
            request: { $0.loadProfilesQuery })
            { (query) -> Signal<ProfileViewCommand> in
                if !query.loadNextPageTrigger { return Signal.empty() }
                guard let page = query.page else { return Signal.empty() }

                return self.userService
                    .getUsers(take: 10, page: page, gender: query.filter.gender)
                    .asSignal(onErrorJustReturn: .failure(.networkError))
                    .map(ProfileViewCommand.loadMoreCompleted)
            }

        Driver
            .system(
                initialState: initial,
                reduce: { (state, command) -> ProfileViewState in
                    switch command {
                    case .loadMore:
                        return state.mutate {
                            $0.loadNextPageTrigger = true
                        }
                    case .loadMoreCompleted(let response):
                        switch response {
                        case .success(let profiles, let nextPage):
                            return state.mutate {
                                $0.profiles = $0.profiles + profiles
                                $0.nextPage = nextPage
                                $0.loadNextPageTrigger = false
                            }
                        case .failure(let error):
                            return state.mutate {
                                $0.failure = error
                                $0.loadNextPageTrigger = false
                            }
                        }
                    }
                },
                feedback: bindUI, loadMore)
            .drive()
            .disposed(by: disposeBag)
    }
}
