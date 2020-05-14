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

class ContainerViewController: UIViewController {
    var listViewController: ListViewController!
    var profileViewController: ProfileViewController!
    let scrollView = UIScrollView()
    
    init(listViewController: ListViewController, profileViewController: ProfileViewController) {
        self.listViewController = listViewController
        self.profileViewController = profileViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

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
