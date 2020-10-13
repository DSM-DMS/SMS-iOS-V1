//
//  OutGoingCompletedViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/13.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class OutGoingCompletedViewController: UIViewController {
    @IBOutlet weak var checkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkButton.addShadow(offset: CGSize(width: 0, height: 2),
                                   color: .lightGray,
                                   shadowRadius: 2,
                                   opacity: 0.7,
                                   cornerRadius: 5)
        
    }
    
}
