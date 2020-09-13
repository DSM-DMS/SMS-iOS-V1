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
        setupUi()
        
    }
    
    func setupUi() {
        
        applyButton.layer.cornerRadius = 3
        applyButton.layer.shadowColor = UIColor.lightGray.cgColor
        applyButton.layer.shadowOpacity = 0.7
        applyButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        applyButton.layer.shadowRadius = 2
    }
    
}
