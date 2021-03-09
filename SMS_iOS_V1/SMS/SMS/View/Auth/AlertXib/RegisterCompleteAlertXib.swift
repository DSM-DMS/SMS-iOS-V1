//
//  RegisterCompleteAlertXib.swift
//  SMS
//
//  Created by 이현욱 on 2021/02/26.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class RegisterCompleteAlertXib: UIView {
    let disposeBag = DisposeBag()
    var sign: (() -> ())? = nil
    
    @IBOutlet weak var checkBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit(){
        let view = Bundle.main.loadNibNamed(RegisterCompleteAlertXib.NibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        bind()
    }
    
    func bind() {
        checkBtn.rx.tap
            .bind { _ in
                self.sign?()
            }.disposed(by: disposeBag)
    }
}

