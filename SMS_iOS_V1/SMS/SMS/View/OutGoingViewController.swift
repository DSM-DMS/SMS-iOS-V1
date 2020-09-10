//
//  OutGoingViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/10.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class OutGoingViewController: UIViewController {
    
    @IBOutlet weak var outGoingApplyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    func setupUI() {
        outGoingApplyButton.layer.cornerRadius = 10
        outGoingApplyButton.layer.shadowColor = UIColor.lightGray.cgColor
        outGoingApplyButton.layer.shadowOpacity = 0.7
        outGoingApplyButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        outGoingApplyButton.layer.shadowRadius = 4
    }
    
}
