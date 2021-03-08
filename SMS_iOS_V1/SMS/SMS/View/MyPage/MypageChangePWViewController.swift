//
//  MypageChangePWViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/15.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit
import RxSwift
import KeychainSwift
import RxCocoa

class MypageChangePWViewController: UIViewController, Storyboarded {
    weak var coordinator: MyPageCoordinator?
    
    let viewModel = MypageChangePWViewModel()
    let disposeBag = DisposeBag()
    
    
    @IBOutlet weak var applyButton: CustomShadowButton!
    @IBOutlet weak var currentPWTextField: UITextField!
    @IBOutlet weak var newPWTextField: UITextField!
    @IBOutlet weak var confirmPWTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        bindAcion()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        coordinator?.disappear()
    }
    
}
extension MypageChangePWViewController {
    func bind() {
        let input = MypageChangePWViewModel.Input.init(currentPWTextFieldDriver: currentPWTextField.rx.text.orEmpty.asDriver(), newPWTextFieldDriver: newPWTextField.rx.text.orEmpty.asDriver(), confirmPWTextFieldDriver: confirmPWTextField.rx.text.orEmpty.asDriver(), changeButtonDrver: applyButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input)
        
        output.result.subscribe { model in
            if model.status == 200 || model.code == 200 {
                print("패스워드 변경 완료")
                let keychain = KeychainSwift()
                keychain.delete("ID")
                keychain.delete("PW")
                NSLog("Keychain Deleted")
            }
        } onError: {_ in
            fatalError("비밀번호 변경 실패")
        }.disposed(by: disposeBag)
    }
    
    func bindAcion() {
        
        backButton.rx.tap
            .bind { _ in
                print("pop")
                self.coordinator?.pop()
            }.disposed(by: disposeBag)
        
        applyButton.rx.tap
            .bind { _ in
//                self.coordinator?.pwConfirm()
            }.disposed(by: disposeBag)
        
        
    }
    
}
