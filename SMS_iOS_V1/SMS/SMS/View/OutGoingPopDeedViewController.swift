//
//  OutGoingPopDeedViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/15.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class OutGoingPopDeedViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    func setupUI() {
        
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.shadowColor = UIColor.lightGray.cgColor
        backgroundView.layer.shadowOpacity = 0.7
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 2)
        backgroundView.layer.shadowRadius = 2
        
    }
}
