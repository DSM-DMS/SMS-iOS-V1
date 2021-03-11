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

protocol Aaaa {
    func logOutAlertIsHidden(_ value: Bool)
}

class MypageViewController: UIViewController, Storyboarded {
    weak var coordinator: MyPageCoordinator?
    var delegate: Aaaa?
    let viewModel = MypageViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var backgroundBtn: UIButton!
    @IBOutlet weak var logOutView: LogOutView!
    @IBOutlet weak var pwChangeButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var introduceDevButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        bindAction()
        setting()
    }
    
    func bind() {
        let mypageData : Observable<MypageModel> = SMSAPIClient.shared.networking(from: .myInfo)
        
        mypageData.subscribe(onNext: { model in
            if model.status == 200 {
                let zero = model.student_number! > 10 ? "" : "0"
                self.nameLabel.text = model.name
                self.statusLabel.text = "\(model.grade!)\(model.group!)" + zero + "\(model.student_number!)"
                let imageURL = URL(string: "https://dsm-sms-s3.s3.ap-northeast-2.amazonaws.com/\(model.profile_uri!)")
                self.imageVIew.kf.setImage(with: imageURL, placeholder: UIImage(named: "profile"))
                self.imageVIew.layer.cornerRadius = self.imageVIew.bounds.height / 2
            }
        }
        ).disposed(by: disposeBag)
    }
    
    func bindAction() {
        backgroundBtn.rx.tap
            .bind { _ in
                self.isAllHidden()
            }.disposed(by: disposeBag)
        
        pwChangeButton.rx.tap
            .bind { _ in
                self.coordinator?.changePW()
            }.disposed(by: disposeBag)
        
        logOutButton.rx.tap
            .bind { _ in
                self.delegate?.logOutAlertIsHidden(false)
                self.logOutView.isHidden = false
                self.backgroundBtn.isHidden = false
                self.logOutView.sign = { b in
                    self.delegate?.logOutAlertIsHidden(true)
                    self.isAllHidden()
                    if b {
                        keyChain.delete("ID")
                        keyChain.delete("PW")
                        UserDefaults.standard.removeObject(forKey: "token")
                        UserDefaults.standard.removeObject(forKey: "uuid")
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
                             color: .gray,
                             shadowRadius: 6,
                             opacity: 1,
                             cornerRadius: 8)
    }
    
    func isAllHidden() {
        logOutView.isHidden = true
        backgroundBtn.isHidden = true
    }
}
