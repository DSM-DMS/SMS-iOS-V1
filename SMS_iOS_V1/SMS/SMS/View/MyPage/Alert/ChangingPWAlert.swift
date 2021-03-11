//
//  ChangingPWAlert.swift
//  SMS
//
//  Created by 이현욱 on 2021/03/11.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class ChangingPWAlert: UIView {
    let disposeBag = DisposeBag()
    var sign: ((Bool) -> ())? = nil
    
    @IBOutlet weak var checkBtn: UIButton!
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
        let view = Bundle.main.loadNibNamed(ChangingPWAlert.NibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        bind()
    }
    
    func bind() {
        checkBtn.rx.tap
            .bind { _ in
                self.sign?(true)
            }.disposed(by: disposeBag)
        
        cancelBtn.rx.tap
            .bind { _ in
                self.sign?(false)
            }.disposed(by: disposeBag)
    }
}
