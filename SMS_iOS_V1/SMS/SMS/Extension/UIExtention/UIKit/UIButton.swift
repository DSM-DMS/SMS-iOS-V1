//
//  UIButton.swift
//  SMS
//
//  Created by 이현욱 on 2020/11/30.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class CustomShadowButton: UIButton {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 5.0;
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.7
    }
}
