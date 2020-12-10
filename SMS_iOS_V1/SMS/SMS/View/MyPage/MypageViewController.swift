//
//  MypageViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/15.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class MypageViewController: UIViewController, Storyboarded {
    weak var coordinator: MyPageCoordinator?
    
    @IBOutlet weak var pwChangeButton: CustomShadowButton!
    @IBOutlet weak var logOutButton: CustomShadowButton!
    @IBOutlet weak var introduceDevButton: CustomShadowButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
