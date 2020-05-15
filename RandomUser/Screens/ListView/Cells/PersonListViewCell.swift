//
//  PersonListViewCell.swift
//  RandomUser
//
//  Created by will on 13/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import UIKit

class PersonListViewCell: UITableViewCell {
    override func awakeFromNib() {
        profileImageView.layer.borderWidth = 0.1
        profileImageView.layer.borderColor = UIColor.clear.cgColor
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2
        profileImageView.clipsToBounds = true
    }

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
}
