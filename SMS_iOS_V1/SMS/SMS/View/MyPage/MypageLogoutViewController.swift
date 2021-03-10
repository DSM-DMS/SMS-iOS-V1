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
        bindAction()
    }
    
}

extension MypageLogoutViewController {
    func bindAction() {
        LogoutButton.rx.tap
            .bind { _ in
                UserDefaults.standard.removeObject(forKey: "token")
                UserDefaults.standard.removeObject(forKey: "uuid")
                self.coordinator?.main()
            }.disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .bind { _ in
                self.coordinator?.pop()
            }.disposed(by: disposeBag)
    }
}
