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
    let disposeBag = DisposeBag()
    weak var coordinator: OutGoingCoordinator?
//    var delegate: dismissBarProtocol?
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var outGoingApplyButton: UIButton!
    @IBOutlet weak var outGoingLogButton: UIButton!
    @IBOutlet weak var outGoingNoticeButton: UIButton!
    @IBOutlet weak var outGoingPopUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        stackView.spacing = UIScreen.main.bounds.height > 800 ? 70 : 35
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
            }
            .disposed(by: disposeBag)
        
        outGoingLogButton.rx.tap
            .bind { self.coordinator?.outGoingLog()
            }
            .disposed(by: disposeBag)
        
        outGoingNoticeButton.rx.tap
            .bind { self.coordinator?.noticeOutGoing()
            }
            .disposed(by: disposeBag)
        
        outGoingPopUpBtn.rx.tap
            .bind { self.coordinator?.popUp()
            }
            .disposed(by: disposeBag)
    }
}


