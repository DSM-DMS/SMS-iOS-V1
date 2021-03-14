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
}


extension MypageChangePWViewController {
    func bind() {
        let input = MypageChangePWViewModel.Input.init(currentPWTextFieldDriver: currentPWTextField.rx.text.orEmpty.asDriver(),
                                                       newPWTextFieldDriver: newPWTextField.rx.text.orEmpty.asDriver(),
                                                       confirmPWTextFieldDriver: confirmPWTextField.rx.text.orEmpty.asDriver(),
                                                       changeButtonDrver: applyButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input)
        
        let isValid = viewModel.isValid(input)
        
        isValid.bind { self.applyButton.isEnabled = $0 }.disposed(by: disposeBag)
        isValid.bind { b in self.applyButton.alpha = b ? 1 : 0.3 }.disposed(by: disposeBag)
        
        output.result.subscribe { model in
            if model.status == 200 {
                keyChain.delete("ID")
                keyChain.delete("PW")
                self.coordinator?.main()
            } else if model.status == 401 {
                self.coordinator?.main()
            }
        } onError: { error in
            if error as? StatusCode == StatusCode.internalServerError {
                self.view.makeToast("인터넷 연결 실패")
            } else {
                self.applyButton.shake()
            }
        }.disposed(by: disposeBag)
    }
    
    func bindAcion() {
        backButton.rx.tap
            .bind { _ in
                print("pop")
                self.coordinator?.pop()
            }.disposed(by: disposeBag)
    }
}
