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
    let networking: Networking
    
    struct Input {
        let idTextFieldSubject = PublishSubject<String>()
        let pwTextFieldSubject = PublishSubject<String>()
        let loginBtnSubject = PublishSubject<Void>()
        let viewDidAppear = PublishSubject<Void>()
    }
    
    struct Output {
        let loginResult: Observable<LoginModel>
        let buttonIsValid: Signal<Bool>
    }
    
    init(networking: Networking) {
        self.networking = networking
        input = Input()
        
        output = Output(loginResult: Observable.merge(input.loginBtnSubject.map {}, input.viewDidAppear.map {})
                            .withLatestFrom(
                                Observable.combineLatest(
                                    input.idTextFieldSubject.map { $0 },
                                    input.pwTextFieldSubject.map { $0 }
                                )
                            )
                            .map { userInfo -> SMSAPI in
                                return SMSAPI.login(userInfo.0, userInfo.1)
                            }
                            .flatMap { request -> Observable<LoginModel> in
                                networking.networking(from: request)
                            },
                        buttonIsValid: Observable.combineLatest(input.idTextFieldSubject.asObservable(),
                                                                input.pwTextFieldSubject.asObservable())
                            .map { id, pw in
                                return id.count > 4 && pw.count > 4
                            }.asSignal(onErrorJustReturn: false))
    }
}
