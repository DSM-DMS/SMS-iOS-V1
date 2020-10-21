//
//  LoginViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/04.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit
import SimpleCheckbox

class LoginViewController: UIViewController {
    
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var IDTextField: UITextField!
    @IBOutlet weak var PWTextField: UITextField!
    @IBOutlet weak var autoLoginCheckBox: Checkbox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shadowSetting()
        checkBoxSetupUI()
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
    
    func checkBoxSetupUI() {
        autoLoginCheckBox.checkedBorderColor = UIColor.gray
        autoLoginCheckBox.uncheckedBorderColor = UIColor.gray
        autoLoginCheckBox.borderStyle = .square
        autoLoginCheckBox.checkmarkColor = UIColor.white
        autoLoginCheckBox.checkmarkStyle = .tick
        
        autoLoginCheckBox.valueChanged = { (ischecked) in
            self.autoLoginCheckBox.layer.backgroundColor = CGColor(red: 83, green: 35, blue: 178, alpha: 1)
        }
    }
}
