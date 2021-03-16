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
import Toast_Swift
import UserNotifications

class OutGoingPopDeedViewController: UIViewController, Storyboarded {
    var b = true
    let disposeBag = DisposeBag()
    weak var coordinator: OutGoingCoordinator?
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var placeLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var studentIDLbl: UILabel!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var outBtn: UIButton!
    @IBOutlet weak var popVCBtn: UIButton!
    @IBOutlet weak var backgroundBtn: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var outStartAlertView: OutGoingStartActionAlert!
    @IBOutlet weak var outGoingEndView: OutGoingEndActionAlertXib!
    
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var IDView: UIView!
    @IBOutlet weak var placeView: UIView!
    @IBOutlet weak var noneOutingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingAlert()
        bindAction()
        bind()
    }
}


extension OutGoingPopDeedViewController: UNUserNotificationCenterDelegate {
    func bindAction() {
        popVCBtn.rx.tap
            .bind { self.coordinator?.pop()}
            .disposed(by: disposeBag)
        
        backgroundBtn.rx.tap
            .bind {
                self.isHiddenAllAlert(true)
            }.disposed(by: disposeBag)
        
        outBtn.rx.tap
            .bind { _ in
                let outingCode = self.b ? "start" : "end"
                
                if self.b { // 스타팅이라는 소리
                    self.isHiddenAllAlert(false, self.outGoingEndView)
                    self.outStartAlertView.sign = { b in
                        self.isHiddenAllAlert(true)
                        if b { // 스타팅일떄 외출시작을 눌렀을때
                            let startOuting: Observable<OutingActionModel> = SMSAPIClient.shared.networking(from: .outingAction(outingCode))
                            
                            startOuting.bind { model in
                                if model.status == 200 {
                                    self.outBtn.setTitle("외출 종료", for: .normal)
                                    self.stateLbl.text = "외출중"
                                    let content = UNMutableNotificationContent()
                                    content.title = "외출이 시작되었습니다."
                                    content.body = "귀사 시간 전까지 귀사 후 외출을 종료해주세요."
                                    let TimeIntervalTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                                    let request = UNNotificationRequest(identifier: "startingOuting", content: content, trigger: TimeIntervalTrigger)
                                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                                    self.outBtn.backgroundColor = .customRed
                                    self.b = false
                                } else if model.status == 401 {
                                    self.coordinator?.main()
                                    return
                                }
                            }.disposed(by: self.disposeBag)
                        }
                    }
                } else { //종료라는 소리
                    self.isHiddenAllAlert(false, self.outStartAlertView)
                    self.outGoingEndView.sign = { b in
                        self.isHiddenAllAlert(true)
                        if b {
                            let endOuting: Observable<OutingActionModel> = SMSAPIClient.shared.networking(from: .outingAction(outingCode))
                            
                            endOuting.bind { model in
                                if model.status == 200 {
                                    self.stateLbl.text = "선생님 방문 인증 필요"
                                    self.stateLbl.textColor = .customRed
                                    self.outBtn.isHidden = true
                                    let content = UNMutableNotificationContent()
                                    content.title = "외출이 종료되었습니다."
                                    content.body = "선생님께 방문하여 최종 확인을 받아주세요."
                                    let TimeIntervalTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                                    let request = UNNotificationRequest(identifier: "endingOuting", content: content, trigger: TimeIntervalTrigger)
                                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                                    self.b = true
                                } else if model.status == 401 {
                                    return
                                }
                            }.disposed(by: self.disposeBag)
                        }
                    }
                }
            }.disposed(by: disposeBag)
    }
    
    func bind() {
        if (UserDefaults.standard.value(forKey: "outing_uuid") as? String) == nil  {
            let outings: Observable<OutGoingLogModel> = SMSAPIClient.shared.networking(from: .lookUpAllOuting(0, 1))
            
            outings.filter {
                if $0.status == 401 {
                    self.isHiddenAllAlert(true)
                    self.coordinator?.main()
                    return false
                }
                
                if $0.outings!.count == 0  {
                    self.isViewHidden(true)
                    return false
                }
                return true
            }
            .map { outing -> (Date, String) in
                return (unix(with: outing.outings![0].start_time), outing.outings![0].outing_uuid)
            }.subscribe(onNext: { (date, uuid) in
                if Calendar.current.isDateInToday(date) {
                    UserDefaults.standard.setValue(uuid, forKey: "outing_uuid")
                    let cardModel: Observable<OutGoingCardModel> = SMSAPIClient.shared.networking(from: .lookUpOutingCard(uuid))
                    cardModel.bind { cardData in
                        if cardData.status == 200 {
                            if Date() == unix(with: cardData.start_time!) {
                                self.setting(cardData)
                            }
                        } else {
                            self.isViewHidden(true)
                        }
                    }.disposed(by: self.disposeBag)
                } else {
                    self.isViewHidden(true)
                }
            }, onError: { error in
                if error as? StatusCode == StatusCode.internalServerError {
                    self.view.makeToast("인터넷 연결 실패")
                }
            }).disposed(by: disposeBag)
        } else {
            let cardModel: Observable<OutGoingCardModel> = SMSAPIClient.shared.networking(from: .lookUpOutingCard("outing_uuid"))
            
            cardModel.filter {
                if $0.status == 401 {
                    self.coordinator?.main()
                }
                return true
            }
            .subscribe(onNext: { cardData in
                if Date() == unix(with: cardData.start_time!) {
                    self.setting(cardData)
                } else  {
                    self.isViewHidden(true)
                }
            }, onError: { error in
                if error as? StatusCode == StatusCode.internalServerError {
                    self.view.makeToast("인터넷 연결 실패")
                }
            }).disposed(by: disposeBag)
        }
    }
    
    func setting(_ cardData: OutGoingCardModel) {
        let imageURL = URL(string: "https://dsm-sms-s3.s3.ap-northeast-2.amazonaws.com/\(cardData.profile_uri!)")
        let startDateComponent: DateComponents = unix(with: cardData.start_time!)
        let endDateComponent: DateComponents = unix(with: cardData.end_time!)
        let zeroDate = startDateComponent.day! < 10 ? "0" : ""
        self.dateLbl.text = "\(startDateComponent.year!).\(startDateComponent.month!)." + zeroDate + "\(startDateComponent.day!)"
        self.nameLbl.text = cardData.name
        let zeroNum = cardData.number! < 10 ? "0" : ""
        self.studentIDLbl.text = "\(cardData.grade!)\(cardData.group!)" + zeroNum + "\(cardData.number!)"
        let endZeroStr = endDateComponent.minute! < 10 ? "0" : ""
        self.endTimeLabel.text = "\(endDateComponent.hour!):\(endZeroStr)\(endDateComponent.minute!)"
        self.placeLbl.text = cardData.place
        if Int(cardData.outing_status!) == 3 && unix(with: cardData.end_time! - 1800) > Date() {
            let content = UNMutableNotificationContent()
            content.title = "외출 종료 30분 전입니다."
            content.body = "30분 이내로 귀사 후 외출을 종료해주세요."
            let date: DateComponents = unix(with: cardData.end_time! - 1800)
            let calendartrigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
            let request = UNNotificationRequest(identifier: "before30", content: content, trigger: calendartrigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        
        let content = UNMutableNotificationContent()
        content.title = "외출 시간이 만료되었습니다."
        content.body = "빠른 기간 내에 귀사 후 외출을 종료해주세요."
        let date: DateComponents = unix(with: cardData.end_time!)
        let calendartrigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "lateOuting", content: content, trigger: calendartrigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        let zeroStr = startDateComponent.minute! < 10 ? "0" : ""
        self.startTimeLbl.text = "\(startDateComponent.hour!):\(zeroStr)\(startDateComponent.minute!)"
        self.profileImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "profile"))
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.height / 2
        let timeCheck = checking(unix(with: cardData.end_time!))
        var string = ""
        switch Int(cardData.outing_status!) {
        case 0, 1:
            string = timeCheck ? "승인 대기": "만료"
            self.stateLbl.textColor = timeCheck ? .label : .customRed
        case 2:
            string = timeCheck ? "외출 가능": "만료"
            self.outBtn.isEnabled = timeCheck ? true : false
            self.outBtn.isHidden = false
            self.stateLbl.textColor = timeCheck ? .label : .customRed
        case 3: string = "외출중"
            self.outBtn.isHidden = false
            self.outBtn.backgroundColor = .customRed
            self.b = false
            self.outBtn.setTitle("외출 종료", for: .normal)
        case 4: string = "선생님 방문 필요"
            self.outBtn.isHidden = true
            self.stateLbl.textColor = .customRed
        case 5: string = "외출 확인 완료"
            self.stateLbl.textColor = .black
        case -1, -2:
            string = timeCheck ? "승인거부": "만료"
            self.stateLbl.textColor = timeCheck ? .label : .customRed
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
        stateView.isHidden = value
        noneOutingView.isHidden = !value
    }
    
    func isHiddenAllAlert(_ value: Bool, _ view: UIView? = nil) {
        outStartAlertView.isHidden = value
        outGoingEndView.isHidden = value
        backgroundBtn.isHidden = value
        
        if let hiddeView = view {
            hiddeView.isHidden = true
        }
    }
    
    func checking(_ endTime: Date) -> Bool {
        return endTime > Date() // 안늦음
    }
    
    func settingAlert() {
        UNUserNotificationCenter.current().delegate = self
        
        outGoingEndView.addShadow(maskValue: true,
                                  offset: CGSize(width: 0, height: 3),
                                  shadowRadius: 6,
                                  opacity: 1,
                                  cornerRadius: 8)
        
        outStartAlertView.addShadow(maskValue: true,
                                    offset: CGSize(width: 0, height: 3),
                                    shadowRadius: 6,
                                    opacity: 1,
                                    cornerRadius: 8)
    }
}

extension OutGoingPopDeedViewController {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        let settingsViewController = UIViewController()
        settingsViewController.view.backgroundColor = .gray
        self.present(settingsViewController, animated: true, completion: nil)
        
    }
}
