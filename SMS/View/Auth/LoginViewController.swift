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
    var bool = false
    let disposeBag = DisposeBag()
    weak var coordinator: LoginCoordinator?
    private let viewModel = LoginViewModel()
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var idTextField: SkyFloatingLabelTextFieldWithIcon! 
    @IBOutlet weak var pwTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var autoLoginCheckBox: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setting()
    }
}

extension LoginViewController {
    func bind() {
        idTextField.rx.text.orEmpty
            .bind(to: viewModel.input.idTextFieldSubject)
            .disposed(by: disposeBag)
        
        pwTextField.rx.text.orEmpty
            .bind(to: viewModel.input.pwTextFieldSubject)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind(to: viewModel.input.loginBtnSubject)
            .disposed(by: disposeBag)
        
        autoLoginCheckBox.rx.tap
            .bind {  _ in
                self.autoLoginCheckBox.isSelected = !self.autoLoginCheckBox.isSelected
                self.bool.toggle()
            }.disposed(by: disposeBag)
        
        registerButton.rx.tap
            .bind { _ in
                self.coordinator?.checkNumber()
            }.disposed(by: disposeBag)
        
        viewModel.buttonIsValid()
            .emit(to: self.loginButton.rx.isEnabled )
            .disposed(by: disposeBag)
        
        viewModel.buttonIsValid().map { $0 ? 1 : 0.3 }
            .emit(to: self.loginButton.rx.alpha)
            .disposed(by: disposeBag)
        
        viewModel.output.result.subscribe { model in
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
    
    func setting() {
        loginButton.addShadow(maskValue: true,
                              offset: CGSize(width: 0, height: 3),
                              shadowRadius: 6,
                              opacity: 1,
                              cornerRadius: 5)
    }
}
