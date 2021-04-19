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
import Toast_Swift

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
        setting()
    }
}

extension CheckCertificationNumberViewController {
    func bind() {
        numberTextField.rx.text.orEmpty
            .bind(to: viewModel.input.numberSubject)
            .disposed(by: disposeBag)
        
        checkBtn.rx.tap
            .bind(to: viewModel.input.checkSubject)
            .disposed(by: disposeBag)
        
        backBtn.rx.tap
            .bind { [weak self] in
                self?.coordinator?.pop()
            }.disposed(by: disposeBag)
        
        alertBtn.rx.tap
            .bind { [weak self] in
                self?.alertAllHidden(false, self?.invalidAlertView)
                self?.inquireAlertView.sign = {
                    self?.alertAllHidden(true)
                }
            }.disposed(by: disposeBag)
        
        viewModel.buttonIsValid()
            .emit(to: self.checkBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.buttonIsValid().map { $0 ? 1 : 0.3 }
            .emit(to: self.checkBtn.rx.alpha)
            .disposed(by: disposeBag)
        
        viewModel.output.certificationNumberModel.subscribe { [weak self] model in
            if model.status == 200 {
                self?.coordinator?.register(model, self?.numberTextField.text! ?? "")
                self?.alertAllHidden(true)
            } else if model.status == 404 {
                self?.alertAllHidden(false, self?.inquireAlertView)
                self?.invalidAlertView.sign = { bool in
                    if bool {
                        self?.numberTextField.text?.removeAll()
                        self?.alertAllHidden(true)
                    } else {
                        self?.coordinator?.pop()
                    }
                }
            }
        } onError: { [weak self] error in
            if error as? StatusCode == StatusCode.internalServerError {
                self?.view.makeToast("인터넷 연결 실패", point: CGPoint(x: screen.width / 2, y: screen.height - 120), title: nil, image: nil, completion: nil)
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
        numberTextField.becomeFirstResponder()
        
        checkBtn.addShadow(maskValue: true,
                           offset: CGSize(width: 0, height: 3),
                           shadowRadius: 6,
                           opacity: 1,
                           cornerRadius: 5)
        
        invalidAlertView.addShadow(maskValue: true,
                                   offset: CGSize(width: 0, height: 3),
                                   shadowRadius: 6,
                                   opacity: 1,
                                   cornerRadius: 8)
        
        inquireAlertView.addShadow(maskValue: true,
                                   offset: CGSize(width: 0, height: 3),
                                   shadowRadius: 6,
                                   opacity: 1,
                                   cornerRadius: 8)
    }
}
