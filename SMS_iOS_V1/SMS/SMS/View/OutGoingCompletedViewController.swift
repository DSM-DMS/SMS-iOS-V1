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
        setupUI()
        
    }
    
    func setupUI() {
        checkButton.layer.cornerRadius = 3
        checkButton.layer.shadowColor = UIColor.lightGray.cgColor
        checkButton.layer.shadowOpacity = 0.7
        checkButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        checkButton.layer.shadowRadius = 2
        
    }
}
