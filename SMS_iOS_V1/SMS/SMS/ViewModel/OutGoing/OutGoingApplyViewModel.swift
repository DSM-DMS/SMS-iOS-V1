//
//  OutGoingApplyViewModel.swift
//  SMS
//
//  Created by DohyunKim on 2020/10/27.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class OutGoingApplyViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let dateDriver:Driver<String>
        let reasonDriver: Driver<String>
        let startTimeDriver: Driver<String>
        let endTimeDriver:Driver<String>
        let placeDriver: Driver<String>
        let diseaseDriver: Driver<Void>
        let applyDriver: Driver<Void>
    }
    
    struct Output {
        let response: Single<OutGoingModel>
        let emergency: Single<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        var b = true
        
        let emergencyState = input.diseaseDriver
            .asObservable()
            .map { _ -> Bool in
                b.toggle()
                return b
            }.asSingle()
        
        let outGoingModel = input.applyDriver.asObservable()
            .withLatestFrom(Observable.combineLatest(input.dateDriver.asObservable(),
                                                     input.startTimeDriver.asObservable(),
                                                     input.endTimeDriver.asObservable(),
                                                     input.placeDriver.asObservable(),
                                                     input.reasonDriver.asObservable()
            ))
            .filter { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty && !$0.3.isEmpty && !$0.4.isEmpty }
            .map { txt -> SMSAPI in
                var str = "normal"
                if b {
                    str = "emergency"
                }
                return SMSAPI.postOuting(unix(with: txt.0) + stringToUnix(with: txt.1), unix(with: txt.0) + stringToUnix(with: txt.2), txt.3, txt.4, str)
            }.flatMap { request -> Observable<OutGoingModel> in
                return SMSAPIClient.shared.networking(from: request)
            }.asSingle()
    
        return Output(response: outGoingModel, emergency: emergencyState)
    }
}
