//
//  LocationLabel+Styles.swift
//  RandomUser
//
//  Created by will on 16/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import UIKit

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
