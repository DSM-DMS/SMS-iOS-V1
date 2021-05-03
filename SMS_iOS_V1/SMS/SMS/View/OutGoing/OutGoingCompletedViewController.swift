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
    var text: String!
    weak var coordinator: OutGoingCoordinator?
    
    @IBOutlet weak var textLbl: UILabel!
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
        textLbl.text = text
        textLbl.tintColor = .white
        textLbl.font = UIFont(name: "Noto Sans CJK KR Medium", size: 23)
        
        self.checkButton.addShadow(maskValue: true,
                                   offset: CGSize(width: 0, height: 2),
                                   shadowRadius: 2,
                                   opacity: 0.7,
                                   cornerRadius: 10)
    }
}

