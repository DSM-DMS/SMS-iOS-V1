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
import Toast_Swift

final class LoginViewController: UIViewController, Storyboarded {
    weak var coordinator: LoginCoordinator?
    private let viewModel = LoginViewModel()
    var bool = false
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
        loginButton.addShadow(maskValue: true,
                              offset: CGSize(width: 0, height: 3),
                              shadowRadius: 6,
                              opacity: 1,
                              cornerRadius: 5)
    }
}

extension LoginViewController {
    func bind() {
        let input = LoginViewModel.Input(idTextFieldDriver: idTextField.rx.text.orEmpty.asDriver(), pwTextFieldDriver:  pwTextField.rx.text.orEmpty.asDriver(), loginBtnDriver: loginButton.rx.tap.asDriver())
        
        let isValid = viewModel.isValid(input)
        
        isValid.bind(to: self.loginButton.rx.isEnabled).disposed(by: disposeBag)
        isValid.map { $0 ? 1 : 0.3 }.bind(to: self.loginButton.rx.alpha).disposed(by: disposeBag)
        
        let output = viewModel.transform(input)
        
        output.result.subscribe { model in
            if model.status == 200 {
                self.coordinator?.tabbar()
                Account.shared.setUD(model.access_token!, model.student_uuid!)
                if self.bool {
                    Account.shared.setKeyChain(self.idTextField.text!, self.pwTextField.text!)
                } else {
                    Account.shared.removeKeyChain()
                }
            } else {
                self.loginButton.shake()
            }
        } onError: { error in
            if error as? StatusCode == StatusCode.internalServerError {
                self.view.makeToast("인터넷 연결 실패", point: CGPoint(x: screen.width / 2, y: screen.height - 120), title: nil, image: nil, completion: nil)
            } else {
                self.loginButton.shake()
            }
        }.disposed(by: disposeBag)
    }
    
    func bindAction() {
        autoLoginCheckBox.rx.tap
            .bind {  _ in
                self.autoLoginCheckBox.isSelected = !self.autoLoginCheckBox.isSelected
                self.bool.toggle()
            }.disposed(by: disposeBag)
        
        registerButton.rx.tap
            .bind { _ in
                self.coordinator?.checkNumber()
            }.disposed(by: disposeBag)
    }
}
