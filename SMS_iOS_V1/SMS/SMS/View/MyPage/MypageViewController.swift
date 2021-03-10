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
    
    let viewModel = MypageViewModel()
    let disposeBag = DisposeBag()
    
    
    @IBOutlet weak var pwChangeButton: CustomShadowButton!
    @IBOutlet weak var logOutButton: CustomShadowButton!
    @IBOutlet weak var introduceDevButton: CustomShadowButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        bind()
        bindAction()
    }
    
    func bind() {
        
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.clear.cgColor
        profileImage.clipsToBounds = true
        
        
        let mypageData : Observable<MypageModel> = SMSAPIClient.shared.networking(from: .myInfo)
        
        mypageData.subscribe(onNext: { model in
            if model.status == 200 {
                self.nameLabel.text = model.name
                
                let numberFormatter = model.student_number! < 10 ? "0" : ""
                
                self.numberLabel.text = String("\(model.grade!)\(model.group!)\(numberFormatter)\(model.student_number!)")
                
                let profileUrl = URL(string: "https://dsm-sms-s3.s3.ap-northeast-2.amazonaws.com/\(model.profile_uri!)")
                
                self.profileImage.kf.setImage(with: profileUrl!)
                
                
            }
        }
        ).disposed(by: disposeBag)
    }
    
    func bindAction() {
        
        pwChangeButton.rx.tap
            .bind { _ in
                self.coordinator?.changePW()
            }.disposed(by: disposeBag)
        
        logOutButton.rx.tap
            .bind { _ in
                self.coordinator?.logout()
            }.disposed(by: disposeBag)
        
        introduceDevButton.rx.tap
            .bind { _ in
                self.coordinator?.introduce()
            }.disposed(by: disposeBag)
    }
}
