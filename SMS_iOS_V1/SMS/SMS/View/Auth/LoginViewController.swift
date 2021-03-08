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
import SkyFloatingLabelTextField

final class LoginViewController: UIViewController, Storyboarded {
    weak var coordinator: LoginCoordinator?
    private let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var idTextField: SkyFloatingLabelTextFieldWithIcon! 
    @IBOutlet weak var pwTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var autoLoginCheckBox: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        bindAction()
        loginButton.addShadow(offset: CGSize(width: 0, height: 3),
                              color: .gray,
                              shadowRadius: 6,
                              opacity: 1,
                              cornerRadius: 5)
    }
}

extension LoginViewController {
    func bind() {
        let input = LoginViewModel.Input(idTextFieldDriver: idTextField.rx.text.orEmpty.asDriver(), pwTextFieldDriver:  pwTextField.rx.text.orEmpty.asDriver(), loginBtnDriver: loginButton.rx.tap.asDriver(), autoLoginDriver: autoLoginCheckBox.rx.tap.asDriver())
        
        let isValid = viewModel.isValid(input)
        
        isValid.bind(to: self.loginButton.rx.isEnabled).disposed(by: disposeBag)
        isValid.map { $0 ? 1 : 0.3 }.bind(to: self.loginButton.rx.alpha).disposed(by: disposeBag)
        
        let output = viewModel.transform(input)
        
        output.result.subscribe { model in
            if model.status == 200 || model.code == 200 {
                self.coordinator?.tabbar()
                if self.autoLoginCheckBox.isSelected {
                    keyChain.set(self.idTextField.text!, forKey: "ID")
                    keyChain.set(self.pwTextField.text!, forKey: "PW")
                } else {
                    keyChain.delete("ID")
                    keyChain.delete("PW")
                }
            } else {
                self.loginButton.shake()
            }
        } onError: { _ in
            self.loginButton.shake()
        }.disposed(by: disposeBag)
    }
    
    func bindAction() {
        registerButton.rx.tap
            .bind { _ in
                self.coordinator?.checkNumber()
            }.disposed(by: disposeBag)
    }
}
