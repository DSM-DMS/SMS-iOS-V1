//
//  UIViewController.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/07.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

protocol Storyboarded {
    static func instantiate(storyboardName: StoryBoardName) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(storyboardName: StoryBoardName) -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName.name!, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
