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
    @IBOutlet weak var outGoingLogButton: UIButton!
    @IBOutlet weak var outGoingNoticeButton: UIButton!
    @IBOutlet weak var outGoingDeedButton: UIButton!
    
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
        
        outGoingLogButton.layer.cornerRadius = 10
        outGoingLogButton.layer.shadowColor = UIColor.lightGray.cgColor
        outGoingLogButton.layer.shadowOpacity = 0.7
        outGoingLogButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        outGoingLogButton.layer.shadowRadius = 4
        
        outGoingDeedButton.layer.cornerRadius = 10
        outGoingDeedButton.layer.shadowColor = UIColor.lightGray.cgColor
        outGoingDeedButton.layer.shadowOpacity = 0.7
        outGoingDeedButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        outGoingDeedButton.layer.shadowRadius = 4
        
        outGoingNoticeButton.layer.cornerRadius = 10
        outGoingNoticeButton.layer.shadowColor = UIColor.lightGray.cgColor
        outGoingNoticeButton.layer.shadowOpacity = 0.7
        outGoingNoticeButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        outGoingNoticeButton.layer.shadowRadius = 4
    }
    
}
