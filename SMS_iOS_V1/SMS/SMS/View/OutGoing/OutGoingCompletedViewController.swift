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
                let controllers = self.coordinator?.nav.viewControllers
                self.coordinator?.nav.popToViewController(controllers![controllers!.count - 2], animated: true)
            }
            .disposed(by: disposeBag)
    }
}

