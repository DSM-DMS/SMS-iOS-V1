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
import EditorJSKit


class MypageViewController: UIViewController, Storyboarded {
    weak var coordinator: MyPageCoordinator?
    
    let viewModel = MypageViewModel()
    let disposeBag = DisposeBag()
    
    
    @IBOutlet weak var pwChangeButton: CustomShadowButton!
    @IBOutlet weak var logOutButton: CustomShadowButton!
    @IBOutlet weak var introduceDevButton: CustomShadowButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        bind()
        bindAction()
    }
    
    func bind() {
        
        let mypageData : Observable<MypageModel> = SMSAPIClient.shared.networking(from: .myInfo)
        
        mypageData.subscribe(onNext: { model in
            if model.status == 200 {
                self.nameLabel.text = model.name
                self.numberLabel.text = String("    \(model.grade!)학년 \(model.student_number!)번")
                //                self.statusLabel.text = String(model.status) 이거 왜 이래대잇누 외출 하면 이거 바꾸도록 해야할듯.
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
