//
//  PersonListViewCell.swift
//  RandomUser
//
//  Created by will on 13/05/20.
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

extension UILabel {
    func drawLocation(address: String?) {
        let location = NSMutableAttributedString()
        let icon = NSTextAttachment()
        icon.image = UIImage(named: "fob")
        icon.bounds = CGRect(x: 0, y: 0, width: 9, height: 13)
        location.append(NSAttributedString(attachment: icon))
        location.append(NSAttributedString(string: " "))
        location.append(NSAttributedString(string: address ?? ""))
        attributedText = location
    }
}

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

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xFF00_0000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00FF_0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000_FF00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x0000_00FF) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
