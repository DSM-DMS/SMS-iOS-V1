//
//  OutGoingStartActionAlert.swift
//  SMS
//
//  Created by 이현욱 on 2021/03/09.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class OutGoingStartActionAlert: UIView {
    let disposeBag = DisposeBag()
    var sign: ((Bool) -> ())? = nil
    
    @IBOutlet weak var applicationBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit(){
        let view = Bundle.main.loadNibNamed(OutGoingStartActionAlert.NibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        bindAction()
    }
}

extension OutGoingStartActionAlert {
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
