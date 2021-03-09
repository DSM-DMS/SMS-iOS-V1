//
//  RegisterViewController.swift
//  SMS
//
//  Created by 이현욱 on 2021/02/24.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import SkyFloatingLabelTextField

class RegisterViewController: UIViewController, Storyboarded {
    var number: Int!
    let disposeBag = DisposeBag()
    let viewModel = RegisterViewModel()
    var data: CertificationNumberModel!
    weak var coordinator: LoginCoordinator?
    
    @IBOutlet weak var inquireAlertView: RegisterInquireAlertXib!
    @IBOutlet weak var completeAlertView: RegisterCompleteAlertXib!
    @IBOutlet weak var usingIDAlertView: RegisterUsingIDAlertXib!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var alertBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var idTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var pwTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        bind()
        bindAction()
    }
}

extension RegisterViewController {
    func setting() {
        phoneNumberLbl.text = data.phone_number
        nameLbl.text = data.name
        numberLbl.text = String(describing: data.grade!) + String(describing: data.group!) + String(describing: data.student_number!)
        
        inquireAlertView.addShadow(offset: CGSize(width: 0, height: 3),
                                   color: .gray,
                                   shadowRadius: 6,
                                   opacity: 1,
                                   cornerRadius: 8)
        
        completeAlertView.addShadow(offset: CGSize(width: 0, height: 3),
                                    color: .gray,
                                    shadowRadius: 6,
                                    opacity: 1,
                                    cornerRadius: 8)
        
        usingIDAlertView.addShadow(offset: CGSize(width: 0, height: 3),
                                   color: .gray,
                                   shadowRadius: 6,
                                   opacity: 1,
                                   cornerRadius: 8)
        
        createBtn.addShadow(offset: CGSize(width: 0, height: 3),
                           color: .gray,
                           shadowRadius: 6,
                           opacity: 1,
                           cornerRadius: 5)
    }
    
    func bind() {
        let input = RegisterViewModel.Input(idDriver: idTextField.rx.text.orEmpty.asDriver(),
                                            pwDriver: pwTextField.rx.text.orEmpty.asDriver(),
                                            createDriver: createBtn.rx.tap.asDriver(),
                                            number: number)
        
        let output = viewModel.transform(input)
        
        let isValid = viewModel.isValid(input)
        
        isValid.bind(to: self.createBtn.rx.isEnabled).disposed(by: disposeBag)
        isValid.map { $0 ? 1 : 0.3 }.bind(to: self.createBtn.rx.alpha).disposed(by: disposeBag)
        
        output.model.bind { model in
            if model.status == 201 {
                self.completeAlertView.isHidden = false
                self.backgroundView.isHidden = false
                self.completeAlertView.sign = {
                    self.allAlertHidden(true)
                    
                    let loginResult: Observable<LoginModel> = SMSAPIClient.shared.networking(from: .login(self.idTextField.text!, self.pwTextField.text!))
                    
                    loginResult.bind { model in
                        UserDefaults.standard.setValue(model.access_token, forKey: "token")
                        UserDefaults.standard.setValue(model.student_uuid, forKey: "uuid")
                    }.disposed(by: self.disposeBag)
                    
                    self.coordinator?.popAll()
                }
            } else if model.status == 409 {
                self.usingIDAlertView.isHidden = false
                self.backgroundView.isHidden = false
                
                self.usingIDAlertView.sign = {
                    self.allAlertHidden(true)
                }
            }
        }.disposed(by: disposeBag)
    }
    
    func bindAction() {
        backBtn.rx.tap
            .bind { _ in
                self.coordinator?.pop()
            }.disposed(by: disposeBag)
        
        alertBtn.rx.tap
            .bind { _ in
                self.inquireAlertView.isHidden = false
                self.backgroundView.isHidden = false
                
                self.inquireAlertView.sign = {
                    self.allAlertHidden(true)
                }
            }.disposed(by: disposeBag)
    }
    
    func allAlertHidden(_ value: Bool) {
        inquireAlertView.isHidden = value
        completeAlertView.isHidden = value
        usingIDAlertView.isHidden = value
        backgroundView.isHidden = value
    }
}
