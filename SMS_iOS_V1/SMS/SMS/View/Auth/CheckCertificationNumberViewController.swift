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
    weak var coordinator: AppCoordinator?
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var alertBtn: UIButton!
    @IBOutlet weak var backgroundBtn: UIButton!
    @IBOutlet weak var invalidAlertView: RegisterInvalidAlertXib!
    @IBOutlet weak var inquireAlertView: RegisterInquireAlertXib!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        bindAction()
    }
}

extension CheckCertificationNumberViewController {
    func bind() {
        let input = CheckNumberViewModel.Input(numberDriver: numberTextField.rx.text.orEmpty.asDriver(),
                                               checkDrvier: checkBtn.rx.tap.asDriver())
        
        let output = viewModel.transform(input)
        
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
        
        backgroundBtn.rx.tap
            .bind { _ in
                self.alertAllHidden(true)
            }.disposed(by: disposeBag)
    }
    
    func alertAllHidden(_ value: Bool, _ option: UIView? = nil) {
        self.backgroundBtn.isHidden = value
        self.inquireAlertView.isHidden = value
        self.invalidAlertView.isHidden = value
        if let optionView = option {
            optionView.isHidden = !value
        }
        
    }
}
