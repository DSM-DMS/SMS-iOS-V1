//
//  CheckCertificationNumberViewController.swift
//  SMS
//
//  Created by 이현욱 on 2021/02/24.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class CheckCertificationNumberViewController: UIViewController, Storyboarded {
    let disposeBag = DisposeBag()
    let viewModel = CheckNumberViewModel()
    weak var coordinator: LoginCoordinator?
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var alertBtn: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var invalidAlertView: RegisterInvalidAlertXib!
    @IBOutlet weak var inquireAlertView: RegisterInquireAlertXib!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        bindAction()
        setting()
    }
}

extension CheckCertificationNumberViewController {
    func bind() {
        let input = CheckNumberViewModel.Input(numberDriver: numberTextField.rx.text.orEmpty.asDriver(),
                                               checkDrvier: checkBtn.rx.tap.asDriver())
        
        let output = viewModel.transform(input)
        
        let isValid = viewModel.isValid(input)
        
        isValid.bind(to: self.checkBtn.rx.isEnabled).disposed(by: disposeBag)
        isValid.map { $0 ? 1 : 0.3 }.bind(to: self.checkBtn.rx.alpha).disposed(by: disposeBag)
        
        output.certificationNumberModel.subscribe(onNext: { model in
            if model.status == 200 {
                self.coordinator?.register(model, self.numberTextField.text!)
                self.alertAllHidden(true)
            } else if model.status == 404 {
                self.alertAllHidden(false, self.inquireAlertView)
                self.invalidAlertView.sign = { bool in
                    if bool {
                        self.numberTextField.text?.removeAll()
                        self.alertAllHidden(true)
                    } else {
                        self.coordinator?.pop()
                    }
                }
            }
        }).disposed(by: disposeBag)
    }
    
    func bindAction() {
        backBtn.rx.tap
            .bind { _ in
                self.coordinator?.pop()
            }.disposed(by: disposeBag)
        
        alertBtn.rx.tap
            .bind { _ in
                self.alertAllHidden(false, self.invalidAlertView)
                self.inquireAlertView.sign = {
                    self.alertAllHidden(true)
                }
            }.disposed(by: disposeBag)
    }
    
    func alertAllHidden(_ value: Bool, _ option: UIView? = nil) {
        self.backgroundView.isHidden = value
        self.inquireAlertView.isHidden = value
        self.invalidAlertView.isHidden = value
        if let optionView = option {
            optionView.isHidden = !value
        }
    }
    
    func setting() {
        checkBtn.addShadow(maskValue: true,
                           offset: CGSize(width: 0, height: 3),
                           color: .gray,
                           shadowRadius: 6,
                           opacity: 1,
                           cornerRadius: 5)
        
        invalidAlertView.addShadow(maskValue: true,
                                   offset: CGSize(width: 0, height: 3),
                                   color: .gray,
                                   shadowRadius: 6,
                                   opacity: 1,
                                   cornerRadius: 8)
        
        inquireAlertView.addShadow(maskValue: true,
                                   offset: CGSize(width: 0, height: 3),
                                   color: .gray,
                                   shadowRadius: 6,
                                   opacity: 1,
                                   cornerRadius: 8)
    }
}
