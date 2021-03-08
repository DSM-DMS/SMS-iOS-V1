//
//  MypageLogoutViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/16.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MypageLogoutViewController: UIViewController, Storyboarded {
    weak var coordinator: MyPageCoordinator?
    
    let viewModel = MypageLogoutViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var backgroundView: CustomShadowView!
    @IBOutlet weak var LogoutButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        bindAction()
    }
    
}

extension MypageLogoutViewController {
    
    func bind() {
//        LogoutButton.rx.tap
//            .bind {
//            self.viewModel.Logout()
//        }.disposed(by: disposeBag)
        //미구현
    }
    
    func bindAction() {
        LogoutButton.rx.tap
            .bind { _ in
                self.coordinator?.pop()
            }.disposed(by: disposeBag)
        //추후 코디네이터 추가 예정
        
        cancelButton.rx.tap
            .bind { _ in
                self.coordinator?.pop()
            }.disposed(by: disposeBag)
    }
}
