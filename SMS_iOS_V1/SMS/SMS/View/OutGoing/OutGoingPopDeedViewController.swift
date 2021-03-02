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
import SwiftUI

class OutGoingPopDeedViewController: UIViewController, Storyboarded {
    let b = true
    let disposeBag = DisposeBag()
    weak var coordinator: OutGoingCoordinator?
    
    @IBOutlet weak var popVCBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var studentIDLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var backgroundView: CustomShadowView!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var placeLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var outBtn: UIButton!
    
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var IDView: UIView!
    @IBOutlet weak var placeView: UIView!
    @IBOutlet weak var noneOutingView: UIView!
    @IBOutlet weak var stateView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        bindAction()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.disappear()
    }
}


extension OutGoingPopDeedViewController {
    func bindAction() {
        popVCBtn.rx.tap
            .bind { self.coordinator?.pop()}
            .disposed(by: disposeBag)
        
        outBtn.rx.tap
            .bind { _ in
                // 외출 시작하겠냐고 알림창
//                if true 면
                let outingCode = self.b ? "start" : "end"
                
                let startOuting: Observable<OutingActionModel> = SMSAPIClient.shared.networking(from: .outingAction(outingCode))
                
                startOuting.bind { model in
                    if model.status == 200 && self.b {
                        self.outBtn.setTitle("외출 종료", for: .normal)
                        self.stateLbl.text = "외출중"
                        self.outBtn.backgroundColor = .customRed
                    } else if model.status == 200 && !self.b {
                        self.stateLbl.text = "선생님 방문 인증 필요"
                        self.stateLbl.tintColor = .customRed
                        self.outBtn.isHidden = true
                    }
                }.disposed(by: self.disposeBag)
                
                
            }.disposed(by: disposeBag)
    }
    // 한번꺼졋다가 커지면 bool값이 초기화되서 start
    
    
    func bind() {
        UserDefaults.standard.removeObject(forKey: "outing_uuid")
        if (UserDefaults.standard.value(forKey: "outing_uuid") as? String) == nil {
            let outings: Observable<OutGoingLogModel> = SMSAPIClient.shared.networking(from: .lookUpAllOuting(0, 1))

            outings.map { outing -> (Date, String) in
                return (unix(with: outing.outings![0].start_time), outing.outings![0].outing_uuid)
            }
            .bind { (date, uuid) in
                if Calendar.current.isDateInToday(date) {
                    UserDefaults.standard.setValue(uuid, forKey: "outing_uuid")
                    let cardModel: Observable<OutGoingCardModel> = SMSAPIClient.shared.networking(from: .lookUpOutingCard)
                    
                    cardModel.bind { cardData in
                        self.setting(cardData)
                    }.disposed(by: self.disposeBag)
                } else {
                    self.isViewHidden(true)
                }
            }.disposed(by: disposeBag)
        } else {
                let cardModel: Observable<OutGoingCardModel> = SMSAPIClient.shared.networking(from: .lookUpOutingCard)
                
                cardModel.bind { cardData in
                    self.setting(cardData)
                }.disposed(by: disposeBag)
        }
    }
    
    func setting(_ cardData: OutGoingCardModel) {
        let imageURL = URL(string: "https://dsm-sms-s3.s3.ap-northeast-2.amazonaws.com/\(cardData.profile_uri!)")
        let startDateComponent: DateComponents = unix(with: cardData.start_time!)
        let endDateComponent: DateComponents = unix(with: cardData.end_time!)
        self.dateLbl.text = "\(startDateComponent.year!)-\(startDateComponent.month!)-\(startDateComponent.day!)"
        self.nameLbl.text = cardData.name
        self.studentIDLbl.text = "\(cardData.grade!)\(cardData.group!)\(cardData.number!)"
        let endZeroStr = endDateComponent.minute! < 10 ? "0" : ""
        self.endTimeLabel.text = "\(endDateComponent.hour!):\(endZeroStr)\(endDateComponent.minute!)"
        self.placeLbl.text = cardData.place
        
        let zeroStr = startDateComponent.minute! < 10 ? "0" : ""
        self.startTimeLbl.text = "\(startDateComponent.hour!):\(zeroStr)\(startDateComponent.minute!)"
        
        let processor = ResizingImageProcessor(referenceSize: CGSize(width: 100, height: 100))
        self.profileImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "profile"), options: [.processor(processor)])
        
        self.profileImageView.contentMode = .scaleAspectFill
        self.profileImageView.layer.cornerRadius = 50
        self.profileImageView.clipsToBounds = true
        
        var string = ""
        switch Int(cardData.outing_status!) {
        case 0, 1: string = "승인 대기"
        case 2: string = "외출 가능"
            self.outBtn.isHidden = false
        case 3: string = "외출중"
            self.outBtn.isHidden = false
            self.outBtn.backgroundColor = .customRed
            self.outBtn.setTitle("외출 종료", for: .normal)
        case 4: string = "선생님 방문 인증 필요"
            self.stateLbl.tintColor = .customRed
        case 5: string = "외출 확인 완료"
            self.stateLbl.tintColor = .black
        case -1, -2: string = "승인거부"
        default: string = "에러"
        }
        self.stateLbl.text = string
    }
    
    func isViewHidden(_ value: Bool) {
        timeView.isHidden = value
        nameView.isHidden = value
        IDView.isHidden = value
        stateView.isHidden = value
        placeView.isHidden = value
        noneOutingView.isHidden = !value
    }
}
