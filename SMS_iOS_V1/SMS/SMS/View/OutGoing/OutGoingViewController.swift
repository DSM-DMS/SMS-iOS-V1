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
    let viewModel = OutGoingViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var outGoingApplyButton: CustomShadowButton!
    @IBOutlet weak var outGoingLogButton: CustomShadowButton!
    @IBOutlet weak var outGoingNoticeButton: CustomShadowButton!
    @IBOutlet weak var outGoingDeedButton: CustomShadowButton!
    
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
            .map { self.coordinator?.outGoingApply() }
            .subscribe()
            .disposed(by: disposeBag)
        
        outGoingLogButton.rx.tap
            .map { self.coordinator?.outGoingLog() }
            .subscribe()
            .disposed(by: disposeBag)
        
        outGoingNoticeButton.rx.tap
            .map { self.coordinator?.noticeOutGoing() }
            .subscribe()
            .disposed(by: disposeBag)
        
        outGoingDeedButton.rx.tap
            .map { self.coordinator?.deedOutGoing() }
            .subscribe()
            .disposed(by: disposeBag)
    }
}
