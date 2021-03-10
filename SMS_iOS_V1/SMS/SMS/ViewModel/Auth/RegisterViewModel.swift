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

class RegisterViewModel: ViewModelType {
    struct Input {
        let idDriver: Driver<String>
        let pwDriver: Driver<String>
        let createDriver: Driver<Void>
        let number: Observable<Int>
    }
    
    struct Output {
        let model: Observable<RegisterModel>
    }
    
    func transform(_ input: Input) -> Output {
        let model = input.createDriver.asObservable()
            .withLatestFrom(Observable.combineLatest(input.idDriver.asObservable(),
                                                     input.pwDriver.asObservable(),
                                                     input.number))
            .map { id, pw, num in
                SMSAPI.register(num, id, pw)
            }.flatMap { request -> Observable<RegisterModel> in
                SMSAPIClient.shared.networking(from: request)
            }
        
            return Output(model: model)
    }
    
    func isValid(_ input: Input) -> Observable<Bool> {
        return Observable.combineLatest(input.idDriver.asObservable(),
                                        input.pwDriver.asObservable())
            .map { id, pw in
                return (id.count > 3 && id.count < 17) && (pw.count > 3 && pw.count < 17)
            }
    }
}
