//
//  LoginViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/04.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var LoginButton: LoginButtonUIExtention!
    @IBOutlet weak var IDTextField: UITextField!
    @IBOutlet weak var PWTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< HEAD
        
    }
    
=======
//        setupUI()
    }
    
    @IBAction func autoLogin(_ sender: UIButton) {
       
        
        
    }
    
    @IBAction func touchUpLoginButton(_ sender: UIButton) {
        print("login")
    }
    
    func setupUI() {
        LoginButton.layer.masksToBounds = false
        LoginButton.layer.cornerRadius = 3
        LoginButton.layer.shadowColor = UIColor.lightGray.cgColor
        LoginButton.layer.shadowOpacity = 0.7
        LoginButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        LoginButton.layer.shadowRadius = 2
    
    }
    
    
    
>>>>>>> TabBar
}
