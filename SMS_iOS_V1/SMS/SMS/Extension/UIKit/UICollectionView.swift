//
//  UICollectionView.swift
//  SMS
//
//  Created by 이현욱 on 2021/03/06.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import UIKit

extension UICollectionView {
    func completion(_ completion: (() -> Void)? = nil) {
        guard let completion = completion else { return }
        layoutIfNeeded()
        completion()
    }
    
    func reloadData(_ completion: (() -> Void)? = nil) {
            reloadData()
            guard let completion = completion else { return }
            layoutIfNeeded()
            completion()
        }
}
