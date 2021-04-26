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
    let disposeBag = DisposeBag()
    let viewModel = OutGoingLogViewModel(network: SMSAPIClient.shared, int: 1)
    var startTime: Date?
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
    
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var IDView: UIView!
    @IBOutlet weak var placeView: UIView!
    @IBOutlet weak var noneOutingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingAlert()
        bind()
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
    
    func isHiddenAllAlert(_ value: Bool) {
        outStartAlertView.isHidden = value
        backgroundBtn.isHidden = value
    }
    
    func settingAlert() {
        self.isViewHidden(true)
        
        UNUserNotificationCenter.current().delegate = self
        outStartAlertView.addShadow(maskValue: true,
                                    offset: CGSize(width: 0, height: 3),
                                    shadowRadius: 6,
                                    opacity: 1,
                                    cornerRadius: 8)
    }
    
    func outing(_ value: Bool) {
        self.stateLbl.text = value ? "외출중" : "선생님 방문 인증 필요"
        self.stateLbl.textColor = value ? .label : .customRed
        self.outBtn.isHidden = !value
        if value {
            self.outBtn.isEnabled = false
            self.outBtn.setTitle("외출중", for: .normal)
            self.outBtn.backgroundColor = .systemBackground
            self.outBtn.layer.borderColor = UIColor.customPurple.cgColor
            self.outBtn.setTitleColor(.customPurple, for: .normal)
            self.outBtn.layer.borderWidth = 1
        }
    }
}



extension OutGoingPopDeedViewController {
    func bind() {
        popVCBtn.rx.tap
            .bind { self.coordinator?.pop()}
            .disposed(by: disposeBag)
        
        backgroundBtn.rx.tap
            .bind {
                self.isHiddenAllAlert(true)
            }.disposed(by: disposeBag)
        
        viewModel.response.filter {
            if $0.status == 401 {
                self.coordinator?.main()
                return false
            }
            
            if $0.outings!.count == 0  {
                return false
            }
            return true
        }
        .map { outing -> (Date, String) in
            return (unix(with: outing.outings![0].start_time), outing.outings![0].outing_uuid)
        }.subscribe(onNext: { (date, uuid) in
            self.startTime = date
            if Calendar.current.isDateInToday(date) {
                UserDefaults.standard.setValue(uuid, forKey: "outing_uuid")
                let cardModel: Observable<OutGoingCardModel> = SMSAPIClient.shared.networking(from: .lookUpOutingCard)
                cardModel.filter {
                    if $0.status == 401 {
                        self.coordinator?.main()
                    }
                    return true
                }
                .bind { cardData in
                    if cardData.status == 200 {
                        self.isViewHidden(false)
                        self.setting(cardData)
                    } else  {
                        self.isViewHidden(true)
                    }
                }.disposed(by: self.disposeBag)
            }
        }, onError: { error in
            if error as? StatusCode == StatusCode.internalServerError {
                self.view.makeToast("인터넷 연결 실패", point: CGPoint(x: screen.width / 2, y: screen.height - 120), title: nil, image: nil, completion: nil)
            }
        }).disposed(by: disposeBag)
        
        outBtn.rx.tap
            .bind { _ in
                self.isHiddenAllAlert(false)
                self.outStartAlertView.sign = { b in
                    self.isHiddenAllAlert(true)
                    guard let startTime = self.startTime else { return }
                    if (b && startTime < Date())  { // 외출 시작시간이 지났을 때 
                        let endOuting: Observable<OutingActionModel> = SMSAPIClient.shared.networking(from: .outingAction("start"))
                        
                        endOuting.subscribe(onNext: { model in
                            if model.status == 200 {
                                self.outing(true)
                                self.makeNoti("외출이 시작되었습니다.", "귀사 시간 전까지 귀사 후 외출을 종료해주세요.", "startingOuting", timeOrDate: true)
                            } else if model.status == 401 {
                                self.coordinator?.main()
                            } else {
                                self.outBtn.shake()
                            }
                        }, onError: { error in
                            if error as? StatusCode == StatusCode.internalServerError {
                                self.view.makeToast("인터넷 연결 실패", point: CGPoint(x: screen.width / 2, y: screen.height - 120), title: nil, image: nil, completion: nil)
                            }
                        }).disposed(by: self.disposeBag)
                    }
                }
            }.disposed(by: disposeBag)
    }
    
    func setting(_ cardData: OutGoingCardModel) {
        let imageURL = URL(string: imageBaseURL + "\(cardData.profile_uri!)")
        self.profileImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "profile"))
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.height / 2
        if Int(cardData.outing_status!) == 3 && unix(with: cardData.end_time! - 1800) > Date() {
            self.makeNoti("외출 종료 30분 전입니다.", "30분 이내로 귀사 후 외출을 종료해주세요.", "before30", timeOrDate: false, unixTime: cardData.end_time! - 1800)
        }
        
        makeNoti("외출 시간이 만료되었습니다.", "빠른 기간 내에 귀사 후 외출을 종료해주세요.", "lateOuting", timeOrDate: false, unixTime: cardData.end_time)
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
        let zeroStr = startDateComponent.minute! < 10 ? "0" : ""
        self.startTimeLbl.text = "\(startDateComponent.hour!):\(zeroStr)\(startDateComponent.minute!)"
        
        let timeCheck = unix(with: cardData.end_time!) < Date()
        var string = ""
        switch Int(cardData.outing_status!) {
        case 0,1:
            string = timeCheck ? "만료" : "승인 대기"
            self.stateLbl.textColor = timeCheck ? .customRed: .label
        case 2:
            string = timeCheck ? "만료" :"외출 가능"
            self.outBtn.isHidden = timeCheck
            self.stateLbl.textColor = timeCheck ? .customRed: .label
        case 3: string = "외출중"
            outing(true)
        case 4:
            outing(false)
        case 5: string = "외출 확인 완료"
            print(string)
            self.stateLbl.textColor = .customBlue
            self.outBtn.isHidden = true
        case -1, -2:
            string = timeCheck ? "만료" : "승인거부"
            self.stateLbl.textColor = timeCheck ? .customRed: .label
        default: string = "에러"
        }
        self.stateLbl.text = string
    }
    
    func makeNoti(_ title: String, _ body: String, _ identifier: String, timeOrDate: Bool, unixTime: Int? = nil) {
        if AppDelegate.notiAllow {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            
            if timeOrDate {
                let TimeIntervalTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: TimeIntervalTrigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            } else {
                let date: DateComponents = unix(with: unixTime!)
                let calendartrigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: calendartrigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
    }
}

extension OutGoingPopDeedViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        let settingsViewController = UIViewController()
        settingsViewController.view.backgroundColor = .gray
        self.present(settingsViewController, animated: true, completion: nil)
    }
}
