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
        setupUI()
        
    }
    
    func setupUI() {
        topView.layer.cornerRadius = 10
        
        deedView.layer.shadowColor = UIColor.lightGray.cgColor
        deedView.layer.shadowOpacity = 0.7
        deedView.layer.shadowOffset = CGSize(width: 0, height: 2)
        deedView.layer.shadowRadius = 2
        
    }
    
}
