//
//  MypageChangePWViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/15.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class MypageChangePWViewController: UIViewController {
    
    @IBOutlet weak var applyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyButton.addShadow(offset: CGSize(width: 0, height: 4),
                              color: .lightGray,
                              shadowRadius: 4,
                              opacity: 0.7,
                              cornerRadius: 10)
    }
}
