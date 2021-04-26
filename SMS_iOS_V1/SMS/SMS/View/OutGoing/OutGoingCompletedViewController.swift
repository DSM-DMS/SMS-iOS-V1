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
    let disposeBag = DisposeBag()
    weak var coordinator: OutGoingCoordinator?
    
    @IBOutlet weak var checkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
        setting()
    }
}



extension OutGoingCompletedViewController {
    private func bindAction() {
        checkButton.rx.tap
            .bind { _ in
                self.coordinator?.popAll()
            }.disposed(by: disposeBag)
    }
    
    func setting() {
        self.checkButton.addShadow(maskValue: true,
                                   offset: CGSize(width: 0, height: 2),
                                   shadowRadius: 2,
                                   opacity: 0.7,
                                   cornerRadius: 10)
    }
}

