//
//  ProfileView.swift
//  RandomUser
//
//  Created by will on 14/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import RxCocoa
import RxFeedback
import RxKingfisher
import RxSwift
import UIKit

extension ProfileCardView {
    static func fromNib() -> ProfileCardView {
        return Bundle.fromNib("ProfileCardView")
    }
}

final class ProfileCardView: UIView {
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var clipView: UIView!

    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var cellLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!

    override func awakeFromNib() {
        profileImageView.layer.masksToBounds = false

        layer.cornerRadius = 12.0

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 2

        clipView.layer.cornerRadius = 12.0
        clipView.clipsToBounds = true

        ageLabel.setupAgeLabel()
    }
}

extension ProfileCardView {
    func drawProfile(_ profile: User) {
        nameLabel.text = "\(profile.title) \(profile.firstName) \(profile.lastName)"

        addressLabel.drawLocation(address: profile.address)
        ageLabel.drawAge(gender: profile.gender, dob: profile.dob)

        if let url = profile.largeImageUrl {
            profileImageView.kf.setImage(with: URL(string: url))
        } else {
            profileImageView.image = nil
        }

        usernameLabel.text = "@\(profile.username)"
        phoneLabel.text = profile.phone ?? ""
        cellLabel.text = profile.cell ?? ""
        emailLabel.text = profile.email ?? ""
    }
}
