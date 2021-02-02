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

class MypageLogoutViewController: UIViewController {
    
    let viewModel = MypageLogoutViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var backgroundView: CustomShadowView!
    @IBOutlet weak var LogoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
}

extension MypageLogoutViewController {
    
    func bind() {
        LogoutButton.rx.tap.bind {
            self.viewModel.Logout()
        }.disposed(by: disposeBag)
        
    }
}
