//
//  AgeLabel+Styles.swift
//  RandomUser
//
//  Created by will on 16/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func setupAgeLabel() {
        layer.cornerRadius = 4
        textColor = .white
        clipsToBounds = true
    }

    func drawAge(gender: String, dob: Date) {
        backgroundColor = gender == "male"
            ? UIColor(hex: "#C9E7F6FF")
            : UIColor(hex: "#F6D2E1FF")

        let age = DateUtils.calcAge(birthday: dob)
        let ageText = NSMutableAttributedString()
        let icon = NSTextAttachment()
        icon.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
        icon.image = gender == "male" ? UIImage(named: "male") : UIImage(named: "female")
        ageText.append(NSAttributedString(string: " "))
        ageText.append(NSAttributedString(attachment: icon))
        ageText.append(NSAttributedString(string: " "))
        ageText.append(NSAttributedString(string: "\(age)"))
        ageText.append(NSAttributedString(string: " "))
        attributedText = ageText
    }
}
