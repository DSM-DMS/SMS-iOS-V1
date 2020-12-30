//
//  OutGoingCompletedViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/13.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class OutGoingCompletedViewController: UIViewController, Storyboarded {
    weak var coordinator: OutGoingCoordinator?
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var checkButton: CustomShadowButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
    }
}

extension OutGoingCompletedViewController {
    private func bindAction() {
        checkButton.rx.tap
            .bind { _ in
                guard var controllers = self.coordinator?.nav.viewControllers else { return }
                let count = controllers.count
                if count > 2 {
                    controllers.removeSubrange(1...count-2)
                }
                self.coordinator?.nav.viewControllers = controllers
                self.coordinator?.nav.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

