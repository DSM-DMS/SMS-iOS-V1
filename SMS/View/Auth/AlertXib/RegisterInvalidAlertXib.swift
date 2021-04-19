//
//  RegisterInvalidAlertXib.swift
//  SMS
//
//  Created by 이현욱 on 2021/02/25.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class RegisterInvalidAlertXib: UIView {
    let disposeBag = DisposeBag()
    var sign: ((Bool) -> ())? = nil
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var retryBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit(){
        let view = Bundle.main.loadNibNamed(RegisterInvalidAlertXib.NibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        bind()
    }
    
    func bind() {
        cancelBtn.rx.tap
            .bind { _ in
                self.sign?(false)
            }.disposed(by: disposeBag)
        
        retryBtn.rx.tap
            .bind { _ in
                self.sign?(true)
            }.disposed(by: disposeBag)
    }
}
