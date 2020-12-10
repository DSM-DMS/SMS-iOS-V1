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

class LoginViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let idTextFieldDriver: Driver<String>
        let pwTextFieldDriver: Driver<String>
        let loginBtnDriver: Driver<Void>
        let autoLoginDriver: Driver<Void>
    }
    
    struct Output {
        let result: Single<LoginModel>
    }
    
    func transform(_ input: Input) -> Output {
        var boolean : Bool = false
        
        input.autoLoginDriver.drive(onNext: { _ in
            if boolean {
                // ketchain 저장 
            } else {
                // delete keychain
            }
            boolean.toggle()
        }).disposed(by: disposeBag)
        
        
        
        let bool = input.loginBtnDriver.asObservable()
            .withLatestFrom(Observable.combineLatest(input.idTextFieldDriver.asObservable(),
                                                     input.pwTextFieldDriver.asObservable()))
            .filter{ !$0.0.isEmpty && !$0.1.isEmpty}
            .map { (id, pw) -> SMSAPI in
                return SMSAPI.login(id, pw)
            }.flatMap { request -> Observable<LoginModel> in
                return SMSAPIClient.shared.networking(from: request)
            }.asSingle()
        
        return Output(result: bool)
        
    }
}
