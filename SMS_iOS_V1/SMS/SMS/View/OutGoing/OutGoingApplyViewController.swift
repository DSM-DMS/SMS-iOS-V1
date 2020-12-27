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

class OutGoingApplyViewController: UIViewController, Storyboarded {
    let disposeBag = DisposeBag()
    weak var coordinator: OutGoingCoordinator?
    let viewModel = OutGoingApplyViewModel()
    //    var delegate: dismissBarProtocol?
    
    @IBOutlet weak var popVCBtn: UIButton!
    @IBOutlet weak var diseaseBtn: UIButton!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var outReasonTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var applyButton: CustomShadowButton!
    @IBOutlet weak var emergencyStateLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        bindAction()
    }
}

extension OutGoingApplyViewController {
    private func bind() {
        self.dateTextField.setInputViewDatePicker(target: self, selector: #selector(tapDone), mode: .date)
        self.startTimeTextField.setInputViewDatePicker(target: self, selector: #selector(tapDonea), mode: .time)
        self.endTimeTextField.setInputViewDatePicker(target: self, selector: #selector(tapDonea), mode: .time)
        
        
        
        
        let input = OutGoingApplyViewModel.Input
            .init(dateDriver: dateTextField.rx.text.orEmpty.asDriver(),
                  reasonDriver: outReasonTextField.rx.text.orEmpty.asDriver(),
                  startTimeDriver: startTimeTextField.rx.text.orEmpty.asDriver(),
                  endTimeDriver: endTimeTextField.rx.text.orEmpty.asDriver(),
                  placeDriver: placeTextField.rx.text.orEmpty.asDriver(),
                  diseaseDriver: diseaseBtn.rx.tap.asDriver(),
                  applyDriver: applyButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input)
        
        output.response.subscribe { model in
            print(model)
            switch model.code {
            case 200:
                self.coordinator?.outGoingCompleted()
            default:
                self.applyButton.shake()
            }
        } onError: { _ in
            self.applyButton.shake()
        }.disposed(by: disposeBag)
        
        output.emergency.subscribe { b in
            if b {
                self.emergencyStateLbl.isHidden = !b
                self.diseaseBtn.titleLabel?.text = "취소"
                self.diseaseBtn.backgroundColor = .red
            } else {
                self.emergencyStateLbl.isHidden = b
                self.diseaseBtn.titleLabel?.text = "질병 외출로 신청하시겠습니까?"
            }
        } onError: { _ in
            self.applyButton.shake()
        }.disposed(by: disposeBag)
    }
    
    private func bindAction() {
        popVCBtn.rx.tap
            .bind { _ in
                //                self.coordinator?.dismissBar(false)
                //                self.coordinator?.pop()
            }
            .disposed(by: disposeBag)
    }
}

extension OutGoingApplyViewController { // 리팩토링 해봅시다
    @objc func tapDone() {
        if let datePicker = self.dateTextField.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "yyyy년 M월 d일"
            self.dateTextField.text =  dateformatter.string(from: datePicker.date)
        }
        self.dateTextField.resignFirstResponder() // 2-5
    }
    
    @objc func tapDonea() {
        if let datePicker = startTimeTextField.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.timeStyle = .short
            startTimeTextField.text = dateformatter.string(from: datePicker.date)
        }
        startTimeTextField.resignFirstResponder() // 2-5
    }
}

/*
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
 
 class OutGoingApplyViewController: UIViewController, Storyboarded {
 let disposeBag = DisposeBag()
 weak var coordinator: OutGoingCoordinator?
 let viewModel = OutGoingApplyViewModel()
 let datePicker = UIDatePicker()
 //    var delegate: dismissBarProtocol?
 
 @IBOutlet weak var popVCBtn: UIButton!
 @IBOutlet weak var diseaseBtn: UIButton!
 @IBOutlet weak var placeTextField: UITextField!
 @IBOutlet weak var startTimeTextField: UITextField!
 @IBOutlet weak var endTimeTextField: UITextField!
 @IBOutlet weak var outReasonTextField: UITextField!
 @IBOutlet weak var dateTextField: UITextField!
 @IBOutlet weak var applyButton: CustomShadowButton!
 
 override func viewDidLoad() {
 super.viewDidLoad()
 bind()
 bindAction()
 
 }
 }
 
 extension OutGoingApplyViewController {
 private func bind() {
 self.dateTextField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
 self.startTimeTextField.setInputViewDatePicker(target: self, selector: #selector(tapDonea))
 self.endTimeTextField.setInputViewDatePicker(target: self, selector: #selector(tapDoneas))
 
 let input = OutGoingApplyViewModel.Input
 .init(dateDriver: dateTextField.rx.text.orEmpty.asDriver(),
 reasonDriver: outReasonTextField.rx.text.orEmpty.asDriver(),
 startTimeDriver: startTimeTextField.rx.text.orEmpty.asDriver(),
 endTimeDriver: endTimeTextField.rx.text.orEmpty.asDriver(),
 placeDriver: placeTextField.rx.text.orEmpty.asDriver(),
 diseaseDriver: diseaseBtn.rx.tap.asDriver(),
 applyDriver: applyButton.rx.tap.asDriver())
 
 let output = viewModel.transform(input)
 
 output.response.subscribe { model in
 switch model.code {
 case 200:
 self.coordinator?.outGoingCompleted()
 case 400:
 self.applyButton.shake()
 default:
 break
 }
 } onError: { _ in
 self.applyButton.shake()
 }.disposed(by: disposeBag)
 }
 
 private func bindAction() {
 popVCBtn.rx.tap
 .bind { _ in
 //                self.coordinator?.dismissBar(false)
 //                self.coordinator?.pop()
 }
 .disposed(by: disposeBag)
 }
 }
 
 extension OutGoingApplyViewController { // 리팩토링 해봅시다
 @objc func tapDone() {
 if let datePicker = self.dateTextField.inputView as? UIDatePicker { // 2-1
 let dateformatter = DateFormatter() // 2-2
 dateformatter.dateStyle = .medium // 2-3
 dateformatter.setLocalizedDateFormatFromTemplate("yyyy년 M월 d일")
 self.dateTextField.text = dateformatter.string(from: datePicker.date) //2-4
 self.datePicker.datePickerMode = .date
 }
 datePicker.datePickerMode = .date
 self.dateTextField.resignFirstResponder() // 2-5
 }
 
 @objc func tapDonea() {
 if let datePicker = self.inputView as? UIDatePicker { // 2-1
 let dateformatter = DateFormatter() // 2-2
 dateformatter.timeStyle = .short
 startTimeTextField.text = dateformatter.string(from: datePicker.date)
 }
 datePicker.datePickerMode = .time
 startTimeTextField.resignFirstResponder() // 2-5
 }
 
 @objc func tapDoneas() {
 if let datePicker = self.inputView as? UIDatePicker { // 2-1
 let dateformatter = DateFormatter() // 2-2
 dateformatter.timeStyle = .short
 endTimeTextField.text = dateformatter.string(from: datePicker.date)
 }
 datePicker.datePickerMode = .time
 endTimeTextField.resignFirstResponder() // 2-5
 }
 }]
 
 */
