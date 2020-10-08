//
//  OutGoingApplyViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/11.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit
class OutGoingApplyViewController: UIViewController {

    @IBOutlet weak var applyButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyButton.addShadow(offset: CGSize(width: 0, height: 2),
                                   color: .lightGray,
                                   shadowRadius: 2,
                                   opacity: 0.7,
                                   cornerRadius: 5)
    }
    
}
