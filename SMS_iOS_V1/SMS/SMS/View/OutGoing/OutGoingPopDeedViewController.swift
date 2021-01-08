//
//  OutGoingPopDeedViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/15.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import Kingfisher

class OutGoingPopDeedViewController: UIViewController, Storyboarded {
    
    let disposeBag = DisposeBag()
    lazy var today = globalDateFormatter(.untilDay, Date())
    weak var coordinator: OutGoingCoordinator?
    
    @IBOutlet weak var popVCBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var studentIDLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var backgroundView: CustomShadowView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var placeLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var startEndOutingBtn: UIButton!
    
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var IDView: UIView!
    @IBOutlet weak var placeView: UIView!
    @IBOutlet weak var noneOutingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        bindAction()
    }
}


extension OutGoingPopDeedViewController {
    func bindAction() {
        popVCBtn.rx.tap
            .bind { self.coordinator?.pop()}
            .disposed(by: disposeBag)
        
        startEndOutingBtn.rx.tap
            .bind { _ in
                guard let uuid = UserDefaults.standard.value(forKey: "\(self.today)") as? String else { return }
                if !self.startEndOutingBtn.isSelected { // 외출 시작
                    let _ : Observable<OutGoingCardActionModel> = SMSAPIClient.shared.networking(from: .outingAction(uuid, "start"))
                } else {
                    self.startEndOutingBtn.isSelected = true
                    self.startEndOutingBtn.setTitle("외출 시작", for: .selected)
                    self.startEndOutingBtn.backgroundColor = .customRed
                    
                    let _ : Observable<OutGoingCardActionModel> = SMSAPIClient.shared.networking(from: .outingAction(uuid, "end"))
                }
            }.disposed(by: disposeBag)
    }
    
    func bind() {
        guard let uuid = UserDefaults.standard.value(forKey: "\(today)") as? String else {
            isViewHidden(true)
            return
        } 
        
        let cardModel: Observable<OutGoingCardModel> = SMSAPIClient.shared.networking(from: .lookUpOutingCard(uuid))
        
        cardModel.bind { cardData in
            let imageURL = URL(string: cardData.profile_uri)
            let dateComponent = unix(with: cardData.start_time)
            self.dateLbl.text = "\(dateComponent.year!)-\(dateComponent.month!)-\(dateComponent.day!)"
            self.timeLbl.text = "\(dateComponent.hour!):\(dateComponent.minute!)"
            self.nameLbl.text = cardData.name
            self.studentIDLbl.text = "\(cardData.grade)\(cardData.group)\(cardData.number)"
            self.profileImageView.kf.setImage(with: imageURL)
            self.placeLbl.text = cardData.place
            
            var string = ""
            switch Int(cardData.outing_status) {
            case 0: string = "외출신청"
            case 1: string = "학부모 승인"
            case 2: string = "선생님 승인"
            case 3:
                string = "외출 시작"
                self.startEndOutingBtn.isHidden = false
            case 4:
                string = "외출 종료"
                self.startEndOutingBtn.isHidden = true
            case 5: string = "외출 인증 승인"
            case -1: string = "학부모 거절"
            case -2: string = "선생님 거절"
            default: string = "에러"
            }
            self.stateLbl.text = string
        }.disposed(by: disposeBag)
    }
    
    func isViewHidden(_ value: Bool) {
        timeView.isHidden = value
        nameView.isHidden = value
        IDView.isHidden = value
        placeView.isHidden = value
        stateView.isHidden = value
        noneOutingView.isHidden = !value
    }
}

//UserDefaults.standard.setValue(cardData.outing_uuid, forKey: "outing_uuid")
// 외출종료 누르면 UserDefaults.standard.removeObject(forKey: "outing_uuid")
// 외출시작, 종료버튼 디자인에 대해 얘기해보기
