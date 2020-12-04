//
//  LoginViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/04.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var loginButton: CustomShadowButton!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var autoLoginCheckBox: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

extension LoginViewController {
<<<<<<< HEAD
    func shadowSetting() {
        self.LoginButton.addShadow(offset: CGSize(width: 0, height: 2),
                                   color: .lightGray,
                                   shadowRadius: 2,
                                   opacity: 0.7,
                                   cornerRadius: 3)
    }
    
    func checkBoxSetupUI() {
        
        var state : Bool = false
        
        autoLoginCheckBox.checkedBorderColor = UIColor.gray
        autoLoginCheckBox.uncheckedBorderColor = UIColor.gray
        autoLoginCheckBox.checkboxFillColor = UIColor.white
        
        autoLoginCheckBox.borderStyle = .square
        autoLoginCheckBox.checkmarkColor = UIColor.white
        autoLoginCheckBox.checkmarkStyle = .tick
        
        autoLoginCheckBox.valueChanged = { (isChecked) in
            
            if (state == false) {
                self.autoLoginCheckBox.checkboxFillColor = UIColor.customPurple
                state = true
            } else {
                self.autoLoginCheckBox.checkboxFillColor = UIColor.white
                state = false
            }
            
            
        }
        
        
=======
    func bind() {
        let input = LoginViewModel.Input.init(idTextFieldDriver: idTextField.rx.text.orEmpty.asDriver(), pwTextFieldDriver: pwTextField.rx.text.orEmpty.asDriver(), loginBtnDriver: loginButton.rx.tap.asDriver(), autoLoginDriver: autoLoginCheckBox.rx.tap.asDriver())
            
        let output = viewModel.transform(input)
        
        output.result.subscribe { model in
            print(model)
            // model에 대한 처리
            // ud에 토큰 저장
            // push
            
        } onError: { _ in
            print("loginBtn 흔들기")
//            self.loginButton.shake
        }.disposed(by: disposeBag)

>>>>>>> Login
    }
}
