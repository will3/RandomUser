//
//  ContainerViewController.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxFeedback

struct ChangePageQuery: Equatable {
    let page: Int
}

struct ContainerViewState: Mutable {
    var page = 0

    var changePageQuery: ChangePageQuery {
        return ChangePageQuery(page: page)
    }

    static let initial = ContainerViewState()
}

enum ContainerViewCommand {
    case scrollToPage(Int)
}

class ContainerViewController: UIViewController {
    var listViewController: ListViewController!
    var profileViewController: ProfileViewController!
    let scrollView = UIScrollView()
    let toolbar = UIToolbar()
    let toolbarHeight = 60
    let profileViewButton = UIBarButtonItem()
    let listViewButton = UIBarButtonItem()

    let disposeBag = DisposeBag()

    init(listViewController: ListViewController, profileViewController: ProfileViewController) {
        self.listViewController = listViewController
        self.profileViewController = profileViewController
        super.init(nibName: nil, bundle: nil)

        listViewController.containerViewController = self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        view.backgroundColor = .white

        setupToolbar()
        setupScrollView()
        setupChildViewControllers()
        
        let bindUI: (Driver<ContainerViewState>) -> Signal<ContainerViewCommand> = bind(self) { me, state in
            let subscriptions: [Disposable] = []
            let events: [Signal<ContainerViewCommand>] = [
                me.listViewButton.rx.tap.asSignal().map { _ in ContainerViewCommand.scrollToPage(0) },
                me.profileViewButton.rx.tap.asSignal().map { _ in ContainerViewCommand.scrollToPage(1) }
            ]
            return Bindings(subscriptions: subscriptions, events: events)
        }
        
        let scrollToPage: (Driver<ContainerViewState>) -> Signal<ContainerViewCommand> = react(request: { $0.changePageQuery }) { query in
            self.scrollToPage(page: query.page)
            return Signal.empty()
        }

        Driver
            .system(
                initialState: ContainerViewState.initial,
                reduce: { (state, event) -> ContainerViewState in
                    switch (event) {
                    case .scrollToPage(let page):
                        return state.mutate {
                            $0.page = page
                        }
                    }
                },
                feedback: bindUI, scrollToPage)
            .drive()
            .disposed(by: disposeBag)
    }
    
    func showProfileViewController() -> ProfileViewController {
        scrollToPage(page: 1)
        return profileViewController
    }
    
    func scrollToPage(page: Int) {
        scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width * CGFloat(page), y: 0),
                                    animated: true)
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
