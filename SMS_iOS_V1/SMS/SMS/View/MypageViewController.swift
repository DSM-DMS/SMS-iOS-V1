//
//  MypageViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/15.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class MypageViewController: UIViewController {
    
    @IBOutlet weak var pwChangeButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var introduceDevButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    func setupUI() {
        
        pwChangeButton.layer.cornerRadius = 10
        pwChangeButton.layer.shadowColor = UIColor.lightGray.cgColor
        pwChangeButton.layer.shadowOpacity = 0.7
        pwChangeButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        pwChangeButton.layer.shadowRadius = 2
        
        logOutButton.layer.cornerRadius = 10
        logOutButton.layer.shadowColor = UIColor.lightGray.cgColor
        logOutButton.layer.shadowOpacity = 0.7
        logOutButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        logOutButton.layer.shadowRadius = 2
        
        introduceDevButton.layer.cornerRadius = 10
        introduceDevButton.layer.shadowColor = UIColor.lightGray.cgColor
        introduceDevButton.layer.shadowOpacity = 0.7
        introduceDevButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        introduceDevButton.layer.shadowRadius = 2
        
        
        
        
    }
    
}
