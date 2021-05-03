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
    let networking: Networking
    
    struct Input {
        let idSubject = PublishSubject<String>()
        let pwSubject = PublishSubject<String>()
        let createSubject = PublishSubject<Void>()
        let numberSubject = BehaviorSubject<Int>(value: 0)
    }
    
    struct Output {
        let model: Observable<RegisterModel>
        let buttonIsValid: Signal<Bool>
    }
    
    init(networking: Networking) {
        self.networking = networking
        
        input = Input()
        
        output = Output(model: input.createSubject.withLatestFrom(Observable.combineLatest(input.numberSubject,
                                                                                           input.idSubject,
                                                                                           input.pwSubject
        ))
        .map { num, id, pw in
            return SMSAPI.register(num, id, pw)
        }.flatMapLatest { request -> Observable<RegisterModel> in
            networking.networking(from: request)
        },
        buttonIsValid: Observable.combineLatest(input.idSubject,
                                                input.pwSubject)
            .map { id, pw in
                return (id.count > 3 && id.count < 17) && (pw.count > 3 && pw.count < 17)
            }.asSignal(onErrorJustReturn: false))
    }
}
