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

extension ProfileView {
    static func fromNib() -> ProfileView {
        return Bundle.fromNib("ProfileView")
    }
}

class ProfileView: UIView {
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var clipView: UIView!

    override func awakeFromNib() {
        profileImageView.layer.masksToBounds = false

        layer.cornerRadius = 12.0

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 2

        clipView.layer.cornerRadius = 12.0
        clipView.clipsToBounds = true
    }
}
