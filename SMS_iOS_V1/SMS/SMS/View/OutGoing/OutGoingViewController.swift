//
//  OutGoingViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/10.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class OutGoingViewController: UIViewController, Storyboarded {
    weak var coordinator: OutGoingCoordinator?
//    var delegate: dismissBarProtocol?
    let disposeBag = DisposeBag()
    
    
    @IBOutlet weak var outGoingApplyButton: CustomShadowButton!
    @IBOutlet weak var outGoingLogButton: CustomShadowButton!
    @IBOutlet weak var outGoingNoticeButton: CustomShadowButton!
    @IBOutlet weak var outGoingPopUpBtn: CustomShadowButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.disappear()
    }
}



extension OutGoingViewController {
    private func bind() {
        outGoingApplyButton.rx.tap
            .bind { self.coordinator?.outGoingApply();
//                self.delegate?.dismissBar(true)
            }
            .disposed(by: disposeBag)
        
        outGoingLogButton.rx.tap
            .bind { self.coordinator?.outGoingLog()
//                self.delegate?.dismissBar(true)
            }
            .disposed(by: disposeBag)
        
        outGoingNoticeButton.rx.tap
            .bind { self.coordinator?.noticeOutGoing()
//                self.delegate?.dismissBar(true)
            }
            .disposed(by: disposeBag)
        
        outGoingPopUpBtn.rx.tap
            .bind { self.coordinator?.popUp()
//                self.delegate?.dismissBar(true)
            }
            .disposed(by: disposeBag)
    }
}


