//
//  MypageChangePWViewModel.swift
//  SMS
//
//  Created by DohyunKim on 2021/01/21.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class MypageChangePWViewModel {
    
    struct Input {
        let currentPWTextFieldDriver: Driver<String>
        let newPWTextFieldDriver: Driver<String>
        let confirmPWTextFieldDriver: Driver<String>
        let changeButtonDrver: Driver<Void>
    }
    
    struct Output {
        let result: Observable<mypagePWChangeModel>
    }
    
    func transform(_ input: Input) -> Output {
        
        
    }
}
