//
//  LoginViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/04.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var IDTextField: UITextField!
    @IBOutlet weak var PWTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func autoLogin(_ sender: UIButton) {
       
        
        
    }
    
    
    func setupUI() {
        LoginButton.layer.cornerRadius = 3
        LoginButton.layer.shadowColor = UIColor.lightGray.cgColor
        LoginButton.layer.shadowOpacity = 0.7
        LoginButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        LoginButton.layer.shadowRadius = 2
    
    }
    
    
    
}
