//
//  FilterToggleCell.swift
//  RandomUser
//
//  Created by will on 14/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

final class FilterCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var toggle: UISwitch!
}

extension FilterCell {
    func configure(row: FilterRow) {
        switch row {
        case let .gender(gender):
            titleLabel.text = "Show me"
            detailLabel.text = gender.format()
        case let .country(code):
            titleLabel.text = "Country"
            detailLabel.text = code?.formatName() ?? "All"
        case let .kitten(kitten):
            titleLabel.text = "Kitten"
            detailLabel.text = kitten ? "Yes" : "No"
        }
    }
}
