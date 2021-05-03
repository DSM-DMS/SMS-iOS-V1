//
//  MypageViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/15.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class MypageViewController: UIViewController, Storyboarded {
    weak var coordinator: MyPageCoordinator?
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var backgroundBtn: UIButton!
    @IBOutlet weak var logOutView: LogOutView!
    @IBOutlet weak var pwChangeButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var introduceDevButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        bindAction()
        setting()
    }
}

extension MypageViewController {
    func bind() {
        let mypageData : Observable<MypageModel> = SMSAPIClient.shared.networking(from: .myInfo)
        
        mypageData.subscribe(onNext: { model in
            if model.status == 200 {
                let zero = model.student_number! > 10 ? "" : "0"
                self.nameLabel.text = model.name
                self.numberLabel.text = "\(model.grade!)\(model.group!)" + zero + "\(model.student_number!)"
                let imageURL = URL(string: "https://dsm-sms-s3.s3.ap-northeast-2.amazonaws.com/\(model.profile_uri!)")
                self.imageVIew.kf.setImage(with: imageURL, placeholder: UIImage(named: "profile"))
                self.imageVIew.layer.cornerRadius = self.imageVIew.bounds.height / 2
            } else if model.status == 401 {
                self.coordinator?.main()
            }
        }, onError: { error in
            if error as? StatusCode == StatusCode.internalServerError {
                self.view.makeToast("인터넷 연결 실패", point: CGPoint(x: screen.width / 2, y: screen.height - 120), title: nil, image: nil, completion: nil)
            }
        }).disposed(by: disposeBag)
    }
    
    func bindAction() {
        backgroundBtn.rx.tap
            .bind { _ in
                self.isAllHidden(true)
            }.disposed(by: disposeBag)
        
        pwChangeButton.rx.tap
            .bind { _ in
                self.coordinator?.changePW()
            }.disposed(by: disposeBag)
        
        logOutButton.rx.tap
            .bind { _ in
                self.isAllHidden(false)
                self.logOutView.sign = { b in
                    self.isAllHidden(true)
                    if b {
                        Account.shared.removeUD()
                        Account.shared.removeKeyChain()
                        self.coordinator?.main()
                    }
                }
            }.disposed(by: disposeBag)
        
        introduceDevButton.rx.tap
            .bind { _ in
                self.coordinator?.introduce()
            }.disposed(by: disposeBag)
    }
    
    func setting() {
        logOutView.addShadow(maskValue: true,
                             offset: CGSize(width: 0, height: 3),
                             shadowRadius: 6,
                             opacity: 1,
                             cornerRadius: 8)
    }
    
    func isAllHidden(_ value: Bool) {
        logOutView.isHidden = value
        backgroundBtn.isHidden = value
    }
}