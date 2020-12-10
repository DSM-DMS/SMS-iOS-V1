//
//  MypageChangePWViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/15.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class MypageChangePWViewController: UIViewController, Storyboarded {
    weak var coordinator: MyPageCoordinator?
    
    @IBOutlet weak var applyButton: CustomShadowButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
