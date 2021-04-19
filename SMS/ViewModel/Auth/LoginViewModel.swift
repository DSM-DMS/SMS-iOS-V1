//
//  LoginViewModel.swift
//  SMS
//
//  Created by DohyunKim on 2020/10/13.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class LoginViewModel {
    let input: Input
    let output: Output
    
    struct Input {
        let idTextFieldSubject = PublishSubject<String>()
        let pwTextFieldSubject = PublishSubject<String>()
        let loginBtnSubject = PublishSubject<Void>()
    }
    
    struct Output {
        let result: Observable<LoginModel>
    }
    
    init() {
        input = Input()
        output = Output(result: input.loginBtnSubject.asObservable()
                            .withLatestFrom(Observable.combineLatest(input.idTextFieldSubject.asObservable(),
                                                                     input.pwTextFieldSubject.asObservable()))
                            .filter{ !$0.0.isEmpty && !$0.1.isEmpty }
                            .map { (id, pw) -> SMSAPI in
                                return SMSAPI.login(id, pw)
                            }.flatMapLatest { request -> Observable<LoginModel> in
                                SMSAPIClient.shared.networking(from: request)
                            }
        )
    }
    
    func buttonIsValid() -> Signal<Bool> {
        return Observable.combineLatest(input.idTextFieldSubject.asObservable(),
                                        input.pwTextFieldSubject.asObservable())
            .map { id, pw in
                return id.count > 4 && pw.count > 4
            }.asSignal(onErrorJustReturn: false)
    }
}
