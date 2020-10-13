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
        shadowSetting()
    }
    
    @IBAction func autoLogin(_ sender: UIButton) {
       
        
        
    }
    
    @IBAction func touchUpLoginButton(_ sender: UIButton) {
        print("login")
    }
    
}

extension LoginViewController {
    func shadowSetting() {
        self.LoginButton.addShadow(offset: CGSize(width: 0, height: 2),
                                   color: .lightGray,
                                   shadowRadius: 2,
                                   opacity: 0.7,
                                   cornerRadius: 3)
    }
}
