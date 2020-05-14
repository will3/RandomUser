//
//  FilterToggleCell.swift
//  RandomUser
//
//  Created by will on 14/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class FilterCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var toggle: UISwitch!
    
    var disposeBagCell: DisposeBag = DisposeBag()
    
    override func prepareForReuse() {
        disposeBagCell = DisposeBag()
    }
}
