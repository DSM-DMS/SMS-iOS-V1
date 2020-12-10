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

class LoginViewController: UIViewController, Storyboarded {
    weak var coordinator: AppCoordinator?
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
    func bind() {
        let input = LoginViewModel.Input.init(idTextFieldDriver: idTextField.rx.text.orEmpty.asDriver(), pwTextFieldDriver: pwTextField.rx.text.orEmpty.asDriver(), loginBtnDriver: loginButton.rx.tap.asDriver(), autoLoginDriver: autoLoginCheckBox.rx.tap.asDriver())
        
        autoLoginCheckBox.rx.tap
            .map { self.autoLoginCheckBox.tintColor = .customPurple }
            .map { self.autoLoginCheckBox.isSelected.toggle() }
            .map { if self.autoLoginCheckBox.isSelected {
                self.autoLoginCheckBox.setImage(UIImage(named: "checkmark.square.fill"), for: .selected)
            } else {
                self.autoLoginCheckBox.setImage(UIImage(named: "stop"), for: .normal)
            }}
            .subscribe()
            .disposed(by: disposeBag)
            
        let output = viewModel.transform(input)
        
        output.result.subscribe { model in
            if model.status == 200 || model.code == 200 {
                self.coordinator?.tabbar()
            } else {
                self.loginButton.shake()
            }
        } onError: { _ in
            self.loginButton.shake() // 지울 것
            self.coordinator?.tabbar()
        }.disposed(by: disposeBag)
    }
}
