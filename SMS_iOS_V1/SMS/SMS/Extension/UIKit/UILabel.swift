//
//  UILabel.swift
//  SMS
//
//  Created by 이현욱 on 2021/03/08.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import UIKit

extension UILabel {
    func dynamicFont(fontSize size: CGFloat, weight: UIFont.Weight) {
        let currentFontName = self.font.fontName
        var calculatedFont: UIFont?
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        
        switch height {
        case 568.0: //iphone 5, SE => 4 inch
            calculatedFont = UIFont(name: currentFontName, size: size * 0.8)
            resizeFont(calculatedFont: calculatedFont, weight: weight)
            break
        case 667.0: //iphone 6, 6s, 7, 8 => 4.7 inch
            calculatedFont = UIFont(name: currentFontName, size: size * 0.92)
            resizeFont(calculatedFont: calculatedFont, weight: weight)
            break
        case 736.0: //iphone 6s+ 6+, 7+, 8+ => 5.5 inch
            calculatedFont = UIFont(name: currentFontName, size: size * 0.95)
            resizeFont(calculatedFont: calculatedFont, weight: weight)
            break
        case 812.0: //iphone X, XS => 5.8 inch
            calculatedFont = UIFont(name: currentFontName, size: size)
            resizeFont(calculatedFont: calculatedFont, weight: weight)
            break
        case 896.0: //iphone XR => 6.1 inch  // iphone XS MAX => 6.5 inch
            calculatedFont = UIFont(name: currentFontName, size: size * 2)
            resizeFont(calculatedFont: calculatedFont, weight: weight)
            break
        default:
            print("not an iPhone")
            break
        }
    }
    
    private func resizeFont(calculatedFont: UIFont?, weight: UIFont.Weight) {
        self.font = calculatedFont
        self.font = UIFont.systemFont(ofSize: calculatedFont!.pointSize, weight: weight)
    }
}
