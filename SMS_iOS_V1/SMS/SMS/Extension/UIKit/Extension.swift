//
//  Extension.swift
//  SMS
//
//  Created by 이현욱 on 2020/10/25.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) {
        let Nib = UINib(nibName: T.NibName, bundle: nil)
        register(Nib, forCellWithReuseIdentifier: T.NibName)
    }
}

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) {
        let Nib = UINib(nibName: T.NibName, bundle: nil)
        register(Nib, forCellReuseIdentifier: T.NibName)
    }
}




