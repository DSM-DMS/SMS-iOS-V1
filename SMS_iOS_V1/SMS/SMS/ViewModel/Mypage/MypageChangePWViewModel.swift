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
    let input: Input
    let output: Output
    
    struct Input {
        let currentPWTextFieldSubject = PublishSubject<String>()
        let newPWTextFieldSubject = PublishSubject<String>()
        let confirmPWTextFieldSubject = PublishSubject<String>()
        let changeButtonSubject = PublishSubject<Void>()
    }
    
    struct Output {
        let result: Observable<mypagePWChangeModel>
    }
    
    init() {
        input = Input()
        output = Output(result: input
                            .changeButtonSubject.asObservable()
                            .withLatestFrom(Observable.combineLatest(input.currentPWTextFieldSubject.asObservable(),
                                                                     input.newPWTextFieldSubject.asObservable(),
                                                                     input.confirmPWTextFieldSubject.asObservable()))
                            .filter { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty }
                            .filter { $0.1 == $0.2 }
                            .map { currentPW, changePW, confirmPW -> SMSAPI in
                                SMSAPI.pwChange(currentPW, changePW)
                            }.flatMap { request -> Observable<mypagePWChangeModel> in
                                SMSAPIClient.shared.networking(from: request)
                            })
    }
    
    func isValid() -> Signal<Bool> {
        return Observable.combineLatest(input.currentPWTextFieldSubject.asObservable(),
                                        input.newPWTextFieldSubject.asObservable(),
                                        input.confirmPWTextFieldSubject.asObservable())
            .map { currentPW, newPW, confirmPW  in
                return !currentPW.isEmpty && !newPW.isEmpty && !confirmPW.isEmpty
            }.asSignal(onErrorJustReturn: false)
    }
    
    func pwCheck() -> Signal<Bool> {
        return input.changeButtonSubject.asObservable()
            .withLatestFrom(Observable.combineLatest(input.currentPWTextFieldSubject.asObservable(),
                                                     input.newPWTextFieldSubject.asObservable(),
                                                     input.confirmPWTextFieldSubject.asObservable()
            ))
            .map { data in
                return data.0 != data.1 && data.1 == data.2
            }.asSignal(onErrorJustReturn: false)
    }
}
