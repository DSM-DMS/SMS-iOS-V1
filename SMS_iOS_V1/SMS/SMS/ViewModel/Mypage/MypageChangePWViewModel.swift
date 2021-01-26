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
        let pwChangeResponse = input.changeButtonDrver.asObservable()
            .withLatestFrom(Observable.combineLatest(input.currentPWTextFieldDriver.asObservable(), input.newPWTextFieldDriver.asObservable(), input.confirmPWTextFieldDriver.asObservable()))
            .filter { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty}
            .map { currentPW, changePW, confirmPW -> SMSAPI in
                guard changePW == confirmPW else { return }
                return SMSAPI.pwChange(currentPW, changePW)
            }.flatMap { request -> Observable<mypagePWChangeModel> in
                SMSAPIClient.shared.networking(from: request)
                
            }
        return Output(result: pwChangeResponse)
        
    }
}
