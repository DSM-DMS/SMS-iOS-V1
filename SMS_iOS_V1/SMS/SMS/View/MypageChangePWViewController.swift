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
        setupUI()
        
    }
    
    func setupUI() {
        
        applyButton.layer.cornerRadius = 10
        applyButton.layer.shadowColor = UIColor.lightGray.cgColor
        applyButton.layer.shadowOpacity = 0.7
        applyButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        applyButton.layer.shadowRadius = 4
        
    }
    
}
