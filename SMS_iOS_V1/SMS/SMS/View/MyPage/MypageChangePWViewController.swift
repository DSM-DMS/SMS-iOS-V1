//
//  MypageChangePWViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/15.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import SkyFloatingLabelTextField

class MypageChangePWViewController: UIViewController, Storyboarded {
    weak var coordinator: MyPageCoordinator?
    
    let viewModel = MypageChangePWViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var applyButton: CustomShadowButton!
    @IBOutlet weak var currentPWTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var newPWTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPWTextField: SkyFloatingLabelTextField!
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
        
        let pwCheck = viewModel.pwCheck(input)
        
        isValid.bind { self.applyButton.isEnabled = $0 }.disposed(by: disposeBag)
        isValid.bind { b in self.applyButton.alpha = b ? 1 : 0.3 }.disposed(by: disposeBag)
        
        pwCheck.bind { if !$0 {
            self.applyButton.shake()
        }}.disposed(by: disposeBag)
        
        output.result.subscribe { model in
            if model.status == 200 {
                Account.shared.removeKeyChain()
                self.coordinator?.main()
            } else if model.status == 401 {
                self.coordinator?.main()
            }
        } onError: { error in
            if error as? StatusCode == StatusCode.internalServerError {
                self.view.makeToast("인터넷 연결 실패", point: CGPoint(x: screen.width / 2, y: screen.height - 120), title: nil, image: nil, completion: nil)
            } else {
                self.applyButton.shake()
            }
        }.disposed(by: disposeBag)
    }
    
    func bindAcion() {
        backButton.rx.tap
            .bind { _ in
                self.coordinator?.pop()
            }.disposed(by: disposeBag)
    }
}
