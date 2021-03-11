//
//  OutGoingApplyViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/11.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import SkyFloatingLabelTextField
import Toast_Swift

class OutGoingApplyViewController: UIViewController, Storyboarded {
    let disposeBag = DisposeBag()
    let viewModel = OutGoingApplyViewModel()
    let bool: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
    weak var coordinator: OutGoingCoordinator?
    
    @IBOutlet weak var aboutOuting: AboutOuting!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var popVCBtn: UIButton!
    @IBOutlet weak var diseaseBtn: UIButton!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var startTimeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var endTimeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var outReasonTextField: UITextField!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var noticeView: OutGoingAlertXib!
    @IBOutlet weak var locationXib: OutGoingLocationAlertXib!
    @IBOutlet weak var emergencyStateLbl: UILabel!
    @IBOutlet weak var hiddenViewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
        bind()
        setting()
        registerForKeyboardNotification()
    }
    
    deinit {
        removeRegisterForKeyboardNotification()
    }
}

extension OutGoingApplyViewController {
    private func bind() {
        let input = OutGoingApplyViewModel.Input(reasonDriver: outReasonTextField.rx.text.orEmpty.asDriver(),
                                                 startTimeDriver: startTimeTextField.rx.text.orEmpty.asDriver(),
                                                 endTimeDriver: endTimeTextField.rx.text.orEmpty.asDriver(),
                                                 placeDriver: self.placeTextField.rx.observe(String.self, "text"),
                                                 applyDriver: aboutOuting.checkBtn.rx.tap.asDriver(),
                                                 diseaseIs: bool)
        
        let output = viewModel.transform(input)
        
        let isValid = viewModel.isValid(input)
        
        isValid.bind { b in self.applyButton.alpha = b ? 1 :  0.3}.disposed(by: disposeBag)
        isValid.bind { self.applyButton.isEnabled = $0 }.disposed(by: disposeBag)
        
        output.response.subscribe { model in
            UserDefaults.standard.setValue(model.outing_uuid, forKey: "outing_uuid")
            switch model.status {
            case 201:
                switch model.code {
                case 0: self.view.makeToast("승인을 받은 후 모바일을 통해 외출을 시작해주세요.")
                case -1: self.view.makeToast("연결된 학부모 계정이 존재하지 않습니다. 선생님께 바로 찾아가 승인을 받아주세요.")
                case -2: self.view.makeToast("학부모가 문자 사용을 동의하지 않았습니다. 선생님께 바로 찾아가 승인을 받아주세요.")
                default:
                    print("에러")
                }
                sleep(1)
                self.coordinator?.outGoingCompleted()
            case 401:
                self.coordinator?.main()
                return
            default:
                self.applyButton.shake()
            }
        } onError: { _ in
            self.applyButton.shake()
        }.disposed(by: disposeBag)
    }
    
    private func bindAction() {
        applyButton.rx.tap
            .bind { _ in
                self.aboutOuting.isHidden = false
                self.hiddenViewButton.isHidden = false
                self.aboutOuting.sign = { b in
                    self.aboutOuting.isHidden = true
                    self.hiddenViewButton.isHidden = true
                }
            }.disposed(by: disposeBag)
        
        hiddenViewButton.rx.tap
            .bind { _ in
                self.hiddenView(true)
            }.disposed(by: disposeBag)
        
        popVCBtn.rx.tap
            .bind { _ in
                self.coordinator?.pop()
            }.disposed(by: disposeBag)
        
        placeTextField.rx.controlEvent(.touchDown)
            .bind { _ in
                self.hiddenViewButton.isHidden = false
                self.locationXib.isHidden = false
                self.locationXib.tableView.rx.itemSelected.subscribe(onNext: { indexPath in
                    let cell = self.locationXib.tableView.cellForRow(at: indexPath) as! LocationTableViewCell
                    self.placeTextField.text = cell.addressLbl.text!
                    self.hiddenViewButton.isHidden = true
                    self.locationXib.isHidden = true
                    
                }).disposed(by: self.disposeBag)
            }.disposed(by: disposeBag)
        
        diseaseBtn.rx.tap
            .bind { [self] _ in
                var bool = false
                self.bool.bind { b in bool = b }.disposed(by: disposeBag)
                if !bool {
                    self.noticeView.isHidden = false
                    self.hiddenViewButton.isHidden = false
                    self.noticeView.sign = { b in
                        self.noticeView.isHidden = true
                        self.hiddenViewButton.isHidden = true
                        self.bool.accept(false)
                        if b {
                            self.diseaseBtn.setTitle("취소", for: .normal)
                            self.emergencyStateLbl.isHidden = !b
                            self.bool.accept(b)
                        }
                    }
                } else {
                    self.diseaseBtn.setTitle("질병 외출로 신청하시겠습니까?", for: .normal)
                    self.emergencyStateLbl.isHidden = true
                    self.bool.accept(false)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func setting() {
        dateLabel.text = globalDateFormatter(.day, Date())
        
        aboutOuting.addShadow(maskValue: true,
                              offset: CGSize(width: 0, height: 3),
                              color: .gray,
                              shadowRadius: 6,
                              opacity: 1,
                              cornerRadius: 8)
        
        locationXib.addShadow(maskValue: true, offset: CGSize(width: 0, height: 3),
                              color: .gray,
                              shadowRadius: 6,
                              opacity: 1,
                              cornerRadius: 8)
        
        noticeView.addShadow(maskValue: true, offset: CGSize(width: 0, height: 3),
                             color: .gray,
                             shadowRadius: 6,
                             opacity: 1,
                             cornerRadius: 8)
    }
}

extension OutGoingApplyViewController {
    @objc func startTime() {
        if let datePicker = startTimeTextField.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.timeStyle = .short
            startTimeTextField.text = "시작시간 " + dateformatter.string(from: datePicker.date)
        }
        startTimeTextField.resignFirstResponder()
    }
    
    @objc func endTime() {
        if let datePicker = endTimeTextField.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.timeStyle = .short
            //            datePicker.maximumDate =
            //            a.hour = 20
            //            a.minute = 30
            //            datePicker.maximumDate = Calendar.current.date(from: a)
            endTimeTextField.text = "도착시간 " + dateformatter.string(from: datePicker.date)
        }
        endTimeTextField.resignFirstResponder()
    }
    
    func hiddenView(_ value: Bool, _ view: UIView? = nil) {
        aboutOuting.isHidden = value
        locationXib.isHidden = value
        noticeView.isHidden = value
        hiddenViewButton.isHidden = value
        if let hiddeView = view {
            hiddeView.isHidden = true
        }
    }
    
    func getMaxMinDate(_ minHour: Int = 0, _ minMinute: Int? = 0, _ maxHour: Int = 0, _ maxMinute: Int? = 0) -> (Date, Date) {
        var dateComponent = Calendar.current.dateComponents([.hour, .minute], from: Date())
        dateComponent.hour = minHour
        dateComponent.minute = minMinute
        let minDate = Calendar.current.date(from: dateComponent)!
        dateComponent.hour = maxHour
        dateComponent.minute = maxMinute
        let maxDate = Calendar.current.date(from: dateComponent)!
        return (minDate, maxDate)
    }
}

extension OutGoingApplyViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func keyBoardShow(notification: NSNotification){
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        if placeTextField.isEditing == true{
            keyboardAnimate(keyboardRectangle: keyboardRectangle, textField: placeTextField)
        }
        else if startTimeTextField.isEditing == true{
            keyboardAnimate(keyboardRectangle: keyboardRectangle, textField: startTimeTextField)
        }
        else if endTimeTextField.isEditing == true{
            keyboardAnimate(keyboardRectangle: keyboardRectangle, textField: endTimeTextField)
        }
        else if outReasonTextField.isEditing == true{
            keyboardAnimate(keyboardRectangle: keyboardRectangle, textField: outReasonTextField)
        }
    }
    
    func registerForKeyboardNotification(){
        startTimeTextField.textAlignment = .center
        endTimeTextField.textAlignment = .center
        self.startTimeTextField.setInputViewDatePicker(target: self, selector: #selector(startTime), mode: .time)
        self.endTimeTextField.setInputViewDatePicker(target: self, selector: #selector(endTime), mode: .time)
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
    
    func keyboardAnimate(keyboardRectangle: CGRect ,textField: UITextField){
        if keyboardRectangle.height > (self.view.frame.height - textField.frame.maxY){
            self.view.transform = CGAffineTransform(translationX: 0, y: (self.view.frame.height - keyboardRectangle.height - textField.frame.maxY))
        }
    }
}
