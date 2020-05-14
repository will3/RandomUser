//
//  FilterFab.swift
//  RandomUser
//
//  Created by will on 14/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import UIKit

class FilterFab : UIView {
    @IBOutlet var button: UIButton!

    override func awakeFromNib() {
        let width = CGFloat(50.0)
        
        layer.cornerRadius = width / 2

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 0.1
        
        snp.makeConstraints { (make) in
            make.width.height.equalTo(width)
        }
    }
}
