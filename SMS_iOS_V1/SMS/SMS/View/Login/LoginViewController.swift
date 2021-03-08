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
import KeychainSwift
import SkyFloatingLabelTextField

class LoginViewController: UIViewController, Storyboarded {
    weak var coordinator: LoginCoordinator?
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var idTextField: SkyFloatingLabelTextFieldWithIcon! 
    @IBOutlet weak var pwTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var autoLoginCheckBox: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        bindAction()
    
    }
}

extension LoginViewController {
    func bind() {
        let input = LoginViewModel.Input.init(idTextFieldDriver: idTextField.rx.text.orEmpty.asDriver(), pwTextFieldDriver: pwTextField.rx.text.orEmpty.asDriver(), loginBtnDriver: loginButton.rx.tap.asDriver(), autoLoginDriver: autoLoginCheckBox.rx.tap.asDriver())
        
        let output = viewModel.transform(input)
        
        output.result.subscribe { model in
            if model.status == 200 {
                UserDefaults.standard.setValue(model.access_token!, forKey: "token")
                UserDefaults.standard.setValue(model.student_uuid!, forKey: "uuid") 
                self.coordinator?.tabbar()
            } else {
                self.loginButton.shake()
            }
        } onError: { _ in
            self.loginButton.shake()
        }.disposed(by: disposeBag)
    }
    
    func bindAction() {
        autoLoginCheckBox.rx.tap
            .bind { _ in
                self.autoLoginCheckBox.isSelected.toggle()
            }.disposed(by: disposeBag)
    }
}
