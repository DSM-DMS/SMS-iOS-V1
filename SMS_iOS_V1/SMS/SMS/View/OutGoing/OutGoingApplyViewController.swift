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

class OutGoingApplyViewController: UIViewController, Storyboarded {
    var b = false
    let disposeBag = DisposeBag()
    let viewModel = OutGoingApplyViewModel()
    //    var delegate: dismissBarProtocol?
    weak var coordinator: OutGoingCoordinator?
    
    
    @IBOutlet weak var popVCBtn: UIButton!
    @IBOutlet weak var diseaseBtn: UIButton!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var startTimeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var endTimeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var outReasonTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var applyButton: CustomShadowButton!
    @IBOutlet weak var noticeView: OutGoingAlertXib!
    @IBOutlet weak var locationXib: OutGoingLocationAlertXib!
    @IBOutlet weak var emergencyStateLbl: UILabel!
    @IBOutlet weak var hiddenViewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        bindAction()
    }
}

extension OutGoingApplyViewController {
    private func bind() {
        startTimeTextField.textAlignment = .center
        endTimeTextField.textAlignment = .center
        
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
//                  아웃팅 유저디폴트에 맞는 키 값 제대로 설정 // 신청한 날짜를 포멧팅해서 키로 넣기
//                globalDateFormatter(.untilDay, dateStr(self.dateTextField.text!))
//
//
//                UserDefaults.standard.setValue(model.outing_uuid, forKey: "outing_uuid")
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
                //              self.coordinator?.dismissBar(false)
                self.coordinator?.pop()
            }
            .disposed(by: disposeBag)
        
        placeTextField.rx.controlEvent(.touchDown)
            .bind { _ in
                self.hiddenView(self.locationXib, false)
                self.locationXib.tableView.rx.itemSelected.subscribe(onNext: { indexPath in
                    let cell = self.locationXib.tableView.cellForRow(at: indexPath) as! LocationTableViewCell
                    self.placeTextField.text = cell.addressLbl.text
                    self.hiddenView(self.locationXib, true)
                }).disposed(by: self.disposeBag)
    }.disposed(by: disposeBag)
        
        diseaseBtn.rx.tap
            .bind { [self] _ in
                if !self.b {
                    self.hiddenView(noticeView, false)
                    self.noticeView.sign = { b in
                        self.hiddenView(noticeView, true)
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

extension OutGoingApplyViewController {
    // 여기 수정
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
    
    func hiddenView(_ view: UIView, _ value: Bool) {
        view.isHidden = value
        hiddenViewButton.isHidden = value
    }
}


// textField 위에 함수들 리팩토링
// 장소 제대로 
