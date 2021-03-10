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
        return rgb(red: 83, green: 35, blue: 178, alpha: 1)
    }
    
    static var customBlack: UIColor {
        return rgb(red: 108, green: 108, blue: 108, alpha: 1)
    }
    
    static var customRed: UIColor {
        return rgb(red: 243, green: 4, blue: 4, alpha: 1)
    }
    
    static var customYellow: UIColor {
        return rgb(red: 254, green: 223, blue: 66, alpha: 1)
    }
    
    static var customOrange: UIColor {
        return rgb(red: 255, green: 145, blue: 0, alpha: 1)
    }
    
    static var customGreen: UIColor {
        return rgb(red: 13, green: 210, blue: 20, alpha: 1)
    }
    
    static var calendarEventRed: UIColor {
        return rgb(red: 255, green: 74, blue: 74, alpha: 1)
    }
    
    static func rgb(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
        return .init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: alpha)
    }
}
