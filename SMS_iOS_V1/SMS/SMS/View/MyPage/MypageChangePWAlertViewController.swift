//
//  MypageChangePWAlert.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/16.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MypageChangePWAlertViewController: UIViewController, Storyboarded {
    weak var coordinator: MyPageCoordinator?
    
    @IBOutlet weak var backgroundView: CustomShadowView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindAction() {
        
        confirmButton.rx.tap
            .bind { _ in
                self.coordinator?.pop()
            }.disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .bind { _ in
                self.coordinator?.pop()
            }.disposed(by: disposeBag)
    }
}
