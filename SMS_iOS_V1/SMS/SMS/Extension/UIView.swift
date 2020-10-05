//
//  UIView.swift
//  SMS
//
//  Created by 이현욱 on 2020/10/05.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) -> Void {
        for view in views {
            self.addSubview(view)
        }
    }
}
