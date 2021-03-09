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

final class LoginViewModel: ViewModelType {
    let disposeBag = DisposeBag()
    
    struct Input {
        let idTextFieldDriver: Driver<String>
        let pwTextFieldDriver: Driver<String>
        let loginBtnDriver: Driver<Void>
        let autoLoginDriver: Driver<Void>
    }
    
    struct Output {
        let result: Observable<LoginModel>
    }
    
    func transform(_ input: Input) -> Output {
        let loginResponse = input.loginBtnDriver.asObservable()
            .debounce(.seconds(1), scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .withLatestFrom(Observable.combineLatest(input.idTextFieldDriver.asObservable(),
                                                     input.pwTextFieldDriver.asObservable()))
            .filter{ !$0.0.isEmpty && !$0.1.isEmpty }
            .map { (id, pw) -> SMSAPI in
                print(id, pw)
                return SMSAPI.login(id, pw)
            }.flatMap { request -> Observable<LoginModel> in
                SMSAPIClient.shared.networking(from: request)
            }.observeOn(MainScheduler.instance)
        return Output(result: loginResponse)
    }
    
    func isValid(_ input: Input) -> Observable<Bool> {
        return Observable.combineLatest(input.idTextFieldDriver.asObservable(),
                                                     input.pwTextFieldDriver.asObservable())
            .map { id, pw in
                return id.count > 4 && pw.count > 4
            }
    }
}
