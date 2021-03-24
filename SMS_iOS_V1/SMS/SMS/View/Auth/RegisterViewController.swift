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
import Toast_Swift

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
        registerForKeyboardNotification()
    }
    
    deinit {
        removeRegisterForKeyboardNotification()
    }
}

extension RegisterViewController {
    func setting() {
        phoneNumberLbl.text = data.phone_number
        nameLbl.text = data.name
        
        let number = data.student_number! < 10 ? "0" : ""
        numberLbl.text = String(describing: data.grade!) + String(describing: data.group!) + number + String(describing: data.student_number!)
        
        inquireAlertView.addShadow(maskValue: true,
                                   offset: CGSize(width: 0, height: 3),
                                   shadowRadius: 6,
                                   opacity: 1,
                                   cornerRadius: 8)
        
        completeAlertView.addShadow(maskValue: true,
                                    offset: CGSize(width: 0, height: 3),
                                    shadowRadius: 6,
                                    opacity: 1,
                                    cornerRadius: 8)
        
        usingIDAlertView.addShadow(maskValue: true,
                                   offset: CGSize(width: 0, height: 3),
                                   shadowRadius: 6,
                                   opacity: 1,
                                   cornerRadius: 8)
        
        createBtn.addShadow(maskValue: true,
                            offset: CGSize(width: 0, height: 3),
                            shadowRadius: 6,
                            opacity: 1,
                            cornerRadius: 8)
    }
    
    func bind() {
        let input = RegisterViewModel.Input(idDriver: idTextField.rx.text.orEmpty.asDriver(),
                                            pwDriver: pwTextField.rx.text.orEmpty.asDriver(),
                                            createDriver: createBtn.rx.tap.asDriver(),
                                            number: Observable.of(number!))
        
        let output = viewModel.transform(input)
        
        let isValid = viewModel.isValid(input)
        
        isValid.bind(to: self.createBtn.rx.isEnabled).disposed(by: disposeBag)
        isValid.map { $0 ? 1 : 0.3 }.bind(to: self.createBtn.rx.alpha).disposed(by: disposeBag)
        
        output.model.subscribe { model in
            if model.status == 201 {
                self.completeAlertView.isHidden = false
                self.backgroundView.isHidden = false
                self.completeAlertView.sign = {
                    self.allAlertHidden(true)
                    
                    let loginResult: Observable<LoginModel> = SMSAPIClient.shared.networking(from: .login(self.idTextField.text!, self.pwTextField.text!))
                    
                    loginResult.bind { model in
                        Account.shared.setUD(model.access_token!, model.student_uuid!)
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
        } onError: { error in
            if error as? StatusCode == StatusCode.internalServerError {
                self.view.makeToast("인터넷 연결 실패")
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

extension RegisterViewController {
    func registerForKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeRegisterForKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardHide(_ notification: Notification){
        self.view.transform = .identity
    }
    
    @objc func keyBoardShow(notification: NSNotification){
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        if idTextField.isEditing == true{
            keyboardAnimate(keyboardRectangle: keyboardRectangle, textField: idTextField)
        }
        else if pwTextField.isEditing == true{
            keyboardAnimate(keyboardRectangle: keyboardRectangle, textField: pwTextField)
        }
    }
    
    func keyboardAnimate(keyboardRectangle: CGRect ,textField: UITextField){
        print(textField.frame.maxY)
        print(self.view.frame.height)
        print(keyboardRectangle.height)
        print(self.view.frame.height - keyboardRectangle.height)
        if textField.frame.maxY > (self.view.frame.height - (keyboardRectangle.height + 200)) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -40)
        }
    }
}
