//
//  OutGoingNoticeViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/13.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class OutGoingNoticeViewController: UIViewController, Storyboarded {
    weak var coordinator: OutGoingCoordinator?
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var popVCBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popVCBtn.rx.tap
            .bind { self.coordinator?.pop() }
            .disposed(by: disposeBag)
    }
    
}
