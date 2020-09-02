//
//  LoginVC.swift
//  SMS_iOS_V1
//
//  Created by DohyunKim on 2020/08/25.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtID: UITextField!
    @IBOutlet weak var txtPW: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        
    }
    
    func setUp() {
        btnLogin.layer.cornerRadius = 0.3
    }
}
