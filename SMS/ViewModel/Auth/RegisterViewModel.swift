//
//  RegisterViewModel.swift
//  SMS
//
//  Created by 이현욱 on 2021/02/26.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

class RegisterViewModel {
    let input: Input
    let output: Output
    
    struct Input {
        let idSubject = PublishSubject<String>()
        let pwSubject = PublishSubject<String>()
        let createSubject = PublishSubject<Void>()
        let numberSubject = PublishSubject<Int>()
    }
    
    struct Output {
        let model: Observable<RegisterModel>
    }
    
    init() {
        input = Input()
        output = Output(model: input.createSubject.asObservable()
                            .withLatestFrom(Observable.combineLatest(input.idSubject.asObservable(),
                                                                     input.pwSubject.asObservable(),
                                                                     input.numberSubject.asObservable()))
                            .map { id, pw, num in
                                return SMSAPI.register(num, id, pw)
                            }.flatMapLatest { request -> Observable<RegisterModel> in
                                SMSAPIClient.shared.networking(from: request)
                            }
        )
    }
    
    
    func buttonIsValid() -> Signal<Bool> {
        return Observable.combineLatest(input.idSubject,
                                        input.pwSubject)
            .map { id, pw in
                return (id.count > 3 && id.count < 17) && (pw.count > 3 && pw.count < 17)
            }.asSignal(onErrorJustReturn: false)
    }
}
