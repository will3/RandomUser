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
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!

    override func awakeFromNib() {
        profileImageView.layer.borderWidth = 0.1
        profileImageView.layer.borderColor = UIColor.clear.cgColor
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2
        profileImageView.clipsToBounds = true

        ageLabel.setupAgeLabel()
    }
}

extension PersonListViewCell {
    func configureUser(_ user: User) {
        nameLabel.text = "\(user.title) \(user.firstName) \(user.lastName)"

        ageLabel.drawAge(gender: user.gender, dob: user.dob)
        locationLabel.drawLocation(address: user.address)

        let image = URL(string: user.thumbImageUrl)
        profileImageView.kf.setImage(with: image)
    }
}
