//
//  OutGoingDeedViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/14.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class OutGoingDeedViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var deedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.addShadow(offset: CGSize(width: 0, height: 2),
                                 color: .lightGray,
                                 shadowRadius: 2,
                                 opacity: 0.7,
                                 cornerRadius: 10)
        deedView.addShadow(offset: CGSize(width: 0, height: 2),
                           color: .lightGray,
                           shadowRadius: 2,
                           opacity: 0.7,
                           cornerRadius: 10)
    }
    
    
}
