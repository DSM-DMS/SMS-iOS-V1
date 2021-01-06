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

class LoginViewController: UIViewController, Storyboarded {
    weak var coordinator: AppCoordinator?
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var autoLoginCheckBox: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

extension LoginViewController {
    func bind() {
        let input = LoginViewModel.Input.init(idTextFieldDriver: idTextField.rx.text.orEmpty.asDriver(), pwTextFieldDriver: pwTextField.rx.text.orEmpty.asDriver(), loginBtnDriver: loginButton.rx.tap.asDriver(), autoLoginDriver: autoLoginCheckBox.rx.tap.asDriver())
        
        autoLoginCheckBox.rx.tap
            .bind { _ in
                self.autoLoginCheckBox.isSelected.toggle()
            }.disposed(by: disposeBag)
        
        let output = viewModel.transform(input)
        
        output.result.subscribe { model in
            if model.status == 200 || model.code == 200 {
                let keyChain = KeychainSwift()
                
                self.coordinator?.tabbar()
                if self.autoLoginCheckBox.isSelected {
                    keyChain.set(self.idTextField.text!, forKey: "ID")
                    print("keychian saved")
                    keyChain.set(self.pwTextField.text!, forKey: "PW")
                } else { 
                    keyChain.delete("ID")
                    print("keychian deleted")
                    keyChain.delete("PW")
                }
            } else {
                self.loginButton.shake()
            }
        } onError: { _ in
            self.loginButton.shake()
        }.disposed(by: disposeBag)
    }
}
