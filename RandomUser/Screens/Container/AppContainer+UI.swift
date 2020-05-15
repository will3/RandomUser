//
//  AppContainerViewController.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import RxCocoa
import RxFeedback
import RxSwift
import SnapKit
import UIKit

class AppContainerViewController: UIViewController {
    var listViewController: ListViewController!
    var profileViewController: ProfileViewController!
    let scrollView = UIScrollView()
    let toolbar = UIToolbar()
    let toolbarHeight = 60
    let profileViewButton = UIBarButtonItem()
    let listViewButton = UIBarButtonItem()

    let userService = UserService()
    
    let disposeBag = DisposeBag()

    init(listViewController: ListViewController, profileViewController: ProfileViewController) {
        self.listViewController = listViewController
        self.profileViewController = profileViewController
        super.init(nibName: nil, bundle: nil)

        listViewController.AppContainerViewController = self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        view.backgroundColor = .white

        setupToolbar()
        setupScrollView()
        setupChildViewControllers()

        let bindUI: AppContainer.Feedback = bind(self) { me, state in
            let subscriptions: [Disposable] = [
                state.map { $0.profiles }.drive(me.listViewController.rx.profiles)
            ]
            let events: [Signal<AppContainer.Event>] = [
                me.listViewButton.rx.tap.asSignal()
                    .map { _ in AppContainer.Event.scrollToPage(0) },
                me.profileViewButton.rx.tap.asSignal()
                    .map { _ in AppContainer.Event.scrollToPage(1) },
                me.listViewController.rx.loadMore.asSignal(onErrorSignalWith: .empty())
                    .map { _ in AppContainer.Event.loadMore }
            ]
            return Bindings(subscriptions: subscriptions, events: events)
        }

        AppContainer.system(
            initialState: AppContainer.initial,
            ui: bindUI,
            scrollToPage: scrollToPage,
            loadProfiles: loadProfiles)
            .drive()
            .disposed(by: disposeBag)
    }

    func showProfileViewController() -> ProfileViewController {
        scrollToPage(1)
        return profileViewController
    }

    func scrollToPage(_ page: Int) {
        scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width * CGFloat(page), y: 0),
                                    animated: true)
    }

    private func loadProfiles(take: Int, page: Int, filter: Filter) -> Observable<GetUsersResponse> {
        return userService.getUsers(take: take, page: page, gender: filter.gender)
    }

    private func setupToolbar() {
        view.addSubview(toolbar)
        toolbar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalTo(view)
            make.height.equalTo(toolbarHeight)
        }

        profileViewButton.image = UIImage(named: "profile_view_icon")
        listViewButton.image = UIImage(named: "list_view_icon")
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [listViewButton, space, profileViewButton]
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.top.equalTo(toolbar.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    private func setupChildViewControllers() {
        addChild(listViewController)
        addChild(profileViewController)

        scrollView.addSubview(listViewController.view)
        scrollView.addSubview(profileViewController.view)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false

        listViewController.view.snp.makeConstraints { make in
            make.width.height.equalTo(scrollView)
            make.left.top.bottom.equalTo(scrollView)
            make.right.equalTo(profileViewController.view.snp.left)
        }

        profileViewController.view.snp.makeConstraints { make in
            make.width.height.equalTo(scrollView)
            make.right.top.bottom.equalTo(scrollView)
        }

        listViewController.didMove(toParent: self)
        profileViewController.didMove(toParent: self)
    }
}
