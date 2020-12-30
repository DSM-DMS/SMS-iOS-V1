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
    var b = false
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
    @IBOutlet weak var noticeView: OutGoingAlertXib!
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
        self.endTimeTextField.setInputViewDatePicker(target: self, selector: #selector(tapDones), mode: .time)
        
        let input = OutGoingApplyViewModel.Input
            .init(dateDriver: dateTextField.rx.text.orEmpty.asDriver(),
                  reasonDriver: outReasonTextField.rx.text.orEmpty.asDriver(),
                  startTimeDriver: startTimeTextField.rx.text.orEmpty.asDriver(),
                  endTimeDriver: endTimeTextField.rx.text.orEmpty.asDriver(),
                  placeDriver: placeTextField.rx.text.orEmpty.asDriver(),
                  applyDriver: applyButton.rx.tap.asDriver(),
                  diseaseIs: self.b
                )
        
        let output = viewModel.transform(input)
        
        output.response.subscribe { model in
            switch model.status {
            case 201:
                UserDefaults.standard.setValue(model.outing_uuid, forKey: "outing_uuid")
                self.coordinator?.outGoingCompleted()
            default:
                self.applyButton.shake()
            }
        } onError: { _ in
            self.applyButton.shake()
        }.disposed(by: disposeBag)        
    }
    
    private func bindAction() {
        popVCBtn.rx.tap
            .bind { _ in
                //                self.coordinator?.dismissBar(false)
                self.coordinator?.pop()
            }
            .disposed(by: disposeBag)
        
        placeTextField.rx.controlEvent(.touchDown)
            .bind { self.coordinator?.locationAlert() }
            .disposed(by: disposeBag)
        
        diseaseBtn.rx.tap
            .bind { [self] _ in
                if !self.b {
                    self.noticeView.isHidden = false
                    self.noticeView.sign = { b in
                        self.noticeView.isHidden = true
                        self.b = b
                        if b {
                            self.diseaseBtn.setTitle("취소", for: .normal)
                            self.emergencyStateLbl.isHidden = !b
                        }
                    }
                } else {
                    self.diseaseBtn.setTitle("질병 외출로 신청하시겠습니까?", for: .normal)
                    self.emergencyStateLbl.isHidden = b
                    self.b.toggle()
                }
            }
            .disposed(by: disposeBag)
    }
}

extension OutGoingApplyViewController: BackWordDataProtocol {
    
    func textForLbl(_ text: String) {
        placeTextField.text = text
    }
    
    func delegate() {
        let storyBoard = UIStoryboard.init(name: "OutGoing", bundle: nil)
        let secVC = storyBoard.instantiateViewController(identifier: "OutGoingLocationAlertViewController") as! OutGoingLocationAlertViewController
        secVC.delegate = self
    }
    // 리팩토링 해봅시다
    @objc func tapDone() {
        if let datePicker = self.dateTextField.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "yyyy년 M월 d일"
            self.dateTextField.text = dateformatter.string(from: datePicker.date)
        }
        self.dateTextField.resignFirstResponder() // 2-5
    }
    
    @objc func tapDonea() {
        if let datePicker = startTimeTextField.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.timeStyle = .short
            startTimeTextField.text = "시작시간 " + dateformatter.string(from: datePicker.date)
        }
        startTimeTextField.resignFirstResponder() // 2-5
    }
    
    @objc func tapDones() {
        if let datePicker = endTimeTextField.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.timeStyle = .short
            endTimeTextField.text = "도착시간 " + dateformatter.string(from: datePicker.date)
        }
        endTimeTextField.resignFirstResponder() // 2-5
    }
}


// textField 위에 함수들 리팩토링
// 장소 제대로 
