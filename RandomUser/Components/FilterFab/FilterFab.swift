//
//  FilterFab.swift
//  RandomUser
//
//  Created by will on 14/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import UIKit

final class FilterFab: UIView {
    @IBOutlet var button: UIButton!

    override func awakeFromNib() {
        let width = CGFloat(60.0)

        layer.cornerRadius = width / 2

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 2

        snp.makeConstraints { make in
            make.width.height.equalTo(width)
        }
        
        self.button.accessibilityIdentifier = AccessibilityIdentifiers.filterButton
    }
}
