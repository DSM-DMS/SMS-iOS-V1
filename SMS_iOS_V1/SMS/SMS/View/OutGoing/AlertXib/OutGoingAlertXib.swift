//
//  view.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/30.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class OutGoingAlertXib: UIView {
    let disposeBag = DisposeBag()
    var sign: ((Bool) -> ())? = nil
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var applicationBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
//        bindAction()
    }
    
    private func commonInit(){
        let view = Bundle.main.loadNibNamed(OutGoingAlertXib.NibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        sign?(false)
    }
    @IBAction func OKTapped(_ sender: UIButton) {
        sign?(true)
    }
}

extension OutGoingAlertXib {
    func bindAction() {
        cancelBtn.rx.tap
            .bind { self.sign?(false) }
            .disposed(by: disposeBag)
        
        applicationBtn.rx.tap
            .bind { _ in
                self.sign?(true)
            }
            .disposed(by: disposeBag)
    }
}
