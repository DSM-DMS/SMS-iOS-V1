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

class MypageChangePWViewModel: ViewModelType {
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
        let pwChangeResponse = input
            .changeButtonDrver.asObservable()
            .withLatestFrom(Observable.combineLatest(input.currentPWTextFieldDriver.asObservable(),
                                                     input.newPWTextFieldDriver.asObservable(),
                                                     input.confirmPWTextFieldDriver.asObservable()))
            .filter { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty }
            .filter { $0.1 == $0.2 }
            .map { currentPW, changePW, confirmPW -> SMSAPI in
                SMSAPI.pwChange(currentPW, changePW)
            }.flatMap { request -> Observable<mypagePWChangeModel> in
                SMSAPIClient.shared.networking(from: request)
            }
        return Output(result: pwChangeResponse)
    }
    
    func isValid(_ input: Input) -> Observable<Bool> {
        return Observable.combineLatest(input.currentPWTextFieldDriver.asObservable(),
                                        input.newPWTextFieldDriver.asObservable(),
                                        input.confirmPWTextFieldDriver.asObservable())
            .map { currentPW, newPW, confirmPW  in
                return !currentPW.isEmpty && !newPW.isEmpty && !confirmPW.isEmpty
            }
    }
    
    func pwCheck(_ input: Input) -> Observable<Bool> {
        return input.changeButtonDrver.asObservable()
            .withLatestFrom(Observable.combineLatest(input.currentPWTextFieldDriver.asObservable(),
                                                     input.newPWTextFieldDriver.asObservable(),
                                                     input.confirmPWTextFieldDriver.asObservable()
            ))
            .map { data in
                return data.0 != data.1 && data.1 == data.2
            }
    }
}
