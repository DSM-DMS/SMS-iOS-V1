//
//  UIColor.swift
//  SMS
//
//  Created by 이현욱 on 2020/10/08.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

extension UIColor {
    static var customPurple: UIColor {
        return UIColor(displayP3Red: 83/255, green: 35/255, blue: 178/255, alpha: 1)
    }
    
    static var customBlack: UIColor {
        return UIColor(displayP3Red: 108/255, green: 108/255, blue: 108/255, alpha: 1)
    }
    
    static func rgb(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
        return .init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: alpha)
    }
}
