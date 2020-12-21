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
        
        let output = viewModel.transform(input)
        
        output.result.subscribe { model in
            if model.status == 200 || model.code == 200 {
                UserDefaults.standard.setValue(model.access_token!, forKey: "token")
                UserDefaults.standard.setValue(model
                                                .student_uuid!, forKey: "uuid")
                self.coordinator?.tabbar()
            } else {
                self.loginButton.shake()
            }
        } onError: { _ in
            self.loginButton.shake()
        }.disposed(by: disposeBag)
        
        // 리팩토링 할 수 있지 않을까
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
    }
}
