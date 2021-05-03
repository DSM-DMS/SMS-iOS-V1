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
    let disposeBag = DisposeBag()
    let viewModel = MypageChangePWViewModel(networking: SMSAPIClient.shared)
    
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var currentPWTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var newPWTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPWTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setting()
    }
}



extension MypageChangePWViewController {
    func setting() {
        applyButton.addShadow(maskValue: true,
                              offset: CGSize(width: 0, height: 3),
                              shadowRadius: 6,
                              opacity: 1,
                              cornerRadius: 8)
    }
    
    func bind() {
        currentPWTextField.rx.text.orEmpty
            .bind(to: viewModel.input.currentPWTextFieldSubject)
            .disposed(by: disposeBag)
        
        newPWTextField.rx.text.orEmpty
            .bind(to: viewModel.input.newPWTextFieldSubject)
            .disposed(by: disposeBag)
        
        confirmPWTextField.rx.text.orEmpty
            .bind(to: viewModel.input.confirmPWTextFieldSubject)
            .disposed(by: disposeBag)
        
        applyButton.rx.tap
            .bind(to: viewModel.input.changeButtonSubject)
            .disposed(by: disposeBag)
        
        viewModel.output.isValid
            .emit { self.applyButton.isEnabled = $0 }
            .disposed(by: disposeBag)
        
        viewModel.output.isValid
            .emit { b in self.applyButton.alpha = b ? 1 : 0.3 }
            .disposed(by: disposeBag)
        
        viewModel.output.pwCheck
            .emit {
                if !$0 {
                    self.applyButton.shake()
                }
            }.disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind { _ in
                self.coordinator?.pop()
            }.disposed(by: disposeBag)
        
        viewModel.output.result.subscribe { model in
            if model.status == 200 {
                Account.shared.removeUD()
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
}
