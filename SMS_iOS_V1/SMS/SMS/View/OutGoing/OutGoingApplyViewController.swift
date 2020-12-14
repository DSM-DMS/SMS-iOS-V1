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
//        showDatePicker()
    }
}

extension OutGoingApplyViewController {
    private func bind() {
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
            .bind {self.coordinator?.pop()}
            .disposed(by: disposeBag)
    }
}

extension OutGoingApplyViewController {
    func showDatePicker(){
//        self.datePicker
//        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        toolbar.setItems([doneButton, cancelButton], animated: false)
        
//        datePicker.inputAccessoryView = toolbar
//        datePicker.inputView = datePicker
//
    }
    
    @objc func donedatePicker(){
//        dateTextField.text = globalDateFormatter(formType(rawValue: formType.day.rawValue)!).string(from: datepicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}
