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
        settingTextField()
        bind()
        setting()
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
            }
            .disposed(by: disposeBag)
        
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
    
    func settingTextField() {
        startTimeTextField.textAlignment = .center
        endTimeTextField.textAlignment = .center
        self.startTimeTextField.setInputViewDatePicker(target: self, selector: #selector(tapDonea), mode: .time)
        self.endTimeTextField.setInputViewDatePicker(target: self, selector: #selector(tapDones), mode: .time)
    }
    
    func setting() {
        dateLabel.text = globalDateFormatter(.day, Date())
        
        aboutOuting.addShadow(offset: CGSize(width: 0, height: 3),
                              color: .gray,
                              shadowRadius: 6,
                              opacity: 1,
                              cornerRadius: 8)
        
        locationXib.addShadow(offset: CGSize(width: 0, height: 3),
                              color: .gray,
                              shadowRadius: 6,
                              opacity: 1,
                              cornerRadius: 8)
        
        noticeView.addShadow(offset: CGSize(width: 0, height: 3),
                             color: .gray,
                             shadowRadius: 6,
                             opacity: 1,
                             cornerRadius: 8)
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
