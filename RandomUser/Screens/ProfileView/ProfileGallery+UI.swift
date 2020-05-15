//
//  ProfileGalleryViewController.swift
//  RandomUser
//
//  Created by will on 14/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import RxCocoa
import RxFeedback
import RxSwift
import RxViewController
import UIKit

struct ProfileGalleryNested {
    let profiles: [User]
    let startIndex: Int
}

class ProfileGalleryViewController: UIViewController {
    var initial = ProfileGallery.initial
    let disposeBag = DisposeBag()
    let swipeView = ProfileSwipeView()
    var nestedState: SharedSequence<DriverSharingStrategy, ProfileGalleryNested>?

    override func viewDidLoad() {
        view.addSubview(swipeView)
        swipeView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        let bindUI: (Driver<ProfileGallery>) -> Signal<ProfileGallery.Event> = bind(self) { me, state in
            var subscriptions: [Disposable] = [
                state.map { $0.index }.distinctUntilChanged().drive(me.swipeView.rx.startIndex),
            ]

            if let nestedState = me.nestedState {
                subscriptions += [
                    nestedState.map { $0.profiles }
                        .distinctUntilChanged()
                        .drive(me.swipeView.rx.profiles),
                    nestedState.map { $0.startIndex }
                        .distinctUntilChanged()
                        .drive(me.swipeView.rx.startIndex),
                ]
            }

            let events: [Signal<ProfileGallery.Event>] = [
            ]

            return Bindings(subscriptions: subscriptions, events: events)
        }

        ProfileGallery.feedback(initialState: initial, ui: bindUI)
            .drive()
            .disposed(by: disposeBag)
    }
}
