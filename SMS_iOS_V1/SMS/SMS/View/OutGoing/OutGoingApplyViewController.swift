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
    let bool: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
    let viewModel = OutGoingApplyViewModel(networking: SMSAPIClient.shared)
    weak var coordinator: OutGoingCoordinator?
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var aboutOuting: AboutOuting!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var popVCBtn: UIButton!
    @IBOutlet weak var diseaseBtn: UIButton!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var outReasonTextField: UITextField!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var noticeView: OutGoingAlertXib!
    @IBOutlet weak var locationXib: OutGoingLocationAlertXib!
    @IBOutlet weak var emergencyStateLbl: UILabel!
    @IBOutlet weak var hiddenViewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        bind()
    }
}



extension OutGoingApplyViewController {
    private func bind() {
        outReasonTextField.rx.text.orEmpty
            .bind(to: viewModel.reasonSubject)
            .disposed(by: disposeBag)
        
        startDatePicker.rx.date
            .bind(to: viewModel.startTimeSubject)
            .disposed(by: disposeBag)
        
        endDatePicker.rx.date
            .bind(to: viewModel.endTimeSubject)
            .disposed(by: disposeBag)
        
        placeTextField.rx.observe(String.self, "text")
            .bind(to: viewModel.placeSubject)
            .disposed(by: disposeBag)
        
        aboutOuting.checkBtn.rx.tap
            .bind(to: viewModel.applySubject)
            .disposed(by: disposeBag)
        
        bool
            .bind(to: viewModel.diseaseIsSubject)
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .emit { [weak self] b in self?.applyButton.alpha = b ? 1 :  0.3 }
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .emit { [weak self] in self?.applyButton.isEnabled = $0 }
            .disposed(by: disposeBag)
        
        popVCBtn.rx.tap
            .bind { _ in
                self.coordinator?.pop()
            }.disposed(by: disposeBag)
        
        hiddenViewButton.rx.tap
            .bind { _ in
                self.placeTextField.isUserInteractionEnabled = true
                self.view.endEditing(true)
                self.hiddenView(true)
            }.disposed(by: disposeBag)
        
        applyButton.rx.tap
            .bind { _ in
                self.aboutOuting.isHidden = false
                self.hiddenViewButton.isHidden = false
                self.aboutOuting.sign = { b in
                    self.aboutOuting.isHidden = true
                    self.hiddenViewButton.isHidden = true
                }
            }.disposed(by: disposeBag)
        
        viewModel.response.subscribe { model in
            UD.setValue(model.outing_uuid, forKey: "outing_uuid")
            var txt = ""
            switch model.status {
            case 201:
                switch model.code {
                case -1:
                    txt = "연결된 학부모 계정이 존재하지 않습니다. 선생님께 바로 찾아가 승인을 받아주세요."
                case -2:
                    txt = "학부모가 문자 사용을 동의하지 않았습니다. 선생님께 바로 찾아가 승인을 받아주세요."
                default:
                    txt = "승인을 받은 후 모바일을 통해 외출을 시작해주세요."
                }
                self.coordinator?.outGoingCompleted(txt)
            case 401:
                self.coordinator?.main()
            default:
                self.applyButton.shake()
            }
        } onError: { error in
            if error as? StatusCode == StatusCode.internalServerError {
                self.view.makeToast("인터넷 연결 실패", point: CGPoint(x: screen.width / 2, y: screen.height - 120), title: nil, image: nil, completion: nil)
            } else {
                self.applyButton.shake()
            }
        }.disposed(by: disposeBag)
        
        placeTextField.rx.controlEvent(.touchDown)
            .bind { _ in
                self.placeTextField.isUserInteractionEnabled = false
                self.hiddenViewButton.isHidden = false
                self.locationXib.isHidden = false
                self.locationXib.tableView.rx.itemSelected.subscribe(onNext: { indexPath in
                    let cell = self.locationXib.tableView.cellForRow(at: indexPath) as! LocationTableViewCell
                    self.placeTextField.text = cell.addressLbl.text!
                    self.hiddenViewButton.isHidden = true
                    self.locationXib.isHidden = true
                    self.placeTextField.isUserInteractionEnabled = true
                }).disposed(by: self.disposeBag)
            }.disposed(by: disposeBag)
        
        diseaseBtn.rx.tap
            .bind { [self] _ in
                self.view.endEditing(true)
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
                              shadowRadius: 6,
                              opacity: 1,
                              cornerRadius: 8)
        
        locationXib.addShadow(maskValue: true,
                              offset: CGSize(width: 0, height: 3),
                              shadowRadius: 6,
                              opacity: 1,
                              cornerRadius: 8)
        
        noticeView.addShadow(maskValue: true,
                             offset: CGSize(width: 0, height: 3),
                             shadowRadius: 6,
                             opacity: 1,
                             cornerRadius: 8)
        
        applyButton.addShadow(maskValue: true,
                              offset: CGSize(width: 0, height: 3),
                              shadowRadius: 6,
                              opacity: 1,
                              cornerRadius: 8)
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
}
