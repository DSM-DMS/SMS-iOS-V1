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
    
    let disposeBag = DisposeBag()
    let viewModel = OutGoingApplyViewModel()
    let bool: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
    weak var coordinator: OutGoingCoordinator?
    
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
        settingTextField()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.disappear()
    }
}

extension OutGoingApplyViewController {
    private func bind() {
        dateLabel.text = globalDateFormatter(.day, Date())
        
        let input = OutGoingApplyViewModel.Input(reasonDriver: outReasonTextField.rx.text.orEmpty.asDriver(),
                                                 startTimeDriver: startTimeTextField.rx.text.orEmpty.asDriver(),
                                                 endTimeDriver: endTimeTextField.rx.text.orEmpty.asDriver(),
                                                 placeDriver: placeTextField.rx.text.orEmpty.asDriver(),
                                                 applyDriver: applyButton.rx.tap.asDriver(),
                                                 diseaseIs: bool)
        
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
                var bool = false
                self.bool.bind { b in bool = b }.disposed(by: disposeBag)
                if !bool {
                    self.hiddenView(noticeView, false)
                    self.noticeView.sign = { b in
                        self.hiddenView(noticeView, true)
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
    
    func settingTextField() {
        startTimeTextField.textAlignment = .center
        endTimeTextField.textAlignment = .center
        self.startTimeTextField.setInputViewDatePicker(target: self, selector: #selector(tapDonea), mode: .time)
        self.endTimeTextField.setInputViewDatePicker(target: self, selector: #selector(tapDones), mode: .time)
    }
}

extension UITextField {
    @objc func tappedField(_ dateFormatter: String? = nil, _ text: String? = nil, _ style: DateFormatter.Style) {
        if let datepicker = self.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.timeStyle = style
            self.text = text ?? "" + dateformatter.string(from: datepicker.date)
        }
        self.resignFirstResponder()
    }
}

extension OutGoingApplyViewController {
    // 여기 수정
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
//            datePicker.maximumDate = 
            //            a.hour = 20
            //            a.minute = 30
            //            datePicker.maximumDate = Calendar.current.date(from: a)
            endTimeTextField.text = "도착시간 " + dateformatter.string(from: datePicker.date)
        }
        endTimeTextField.resignFirstResponder() // 2-5
    }
    
    func hiddenView(_ view: UIView, _ value: Bool) {
        view.isHidden = value
        hiddenViewButton.isHidden = value
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
