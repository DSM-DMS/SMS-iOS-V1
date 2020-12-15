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
    }
    
    func transform(_ input: Input) -> Output {
        var emergencyState = false
        let outGoingModel = input.applyDriver.asObservable()
            .withLatestFrom(Observable.combineLatest(input.dateDriver.asObservable(),
                                                     input.startTimeDriver.asObservable(),
                                                     input.endTimeDriver.asObservable(),
                                                     input.placeDriver.asObservable(),
                                                     input.reasonDriver.asObservable(),
                                                     input.diseaseDriver.asObservable()
            ))
            .filter { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty && !$0.3.isEmpty && !$0.4.isEmpty }
            .map { text -> SMSAPI in
                emergencyState.toggle()
                var situation: String
                if emergencyState {
                    situation = "emergency"
                } else {
                    situation = "normal"
                }
                let startInt = DateToUnixStamp(with: text.0 + text.1)
                let endInt = DateToUnixStamp(with: text.0 + text.2)
                return SMSAPI.postOuting(startInt, endInt, text.2, text.3, situation)
            }.flatMap { request -> Observable<OutGoingModel> in
                return SMSAPIClient.shared.networking(from: request)
            }.asSingle()
        
        return Output(response: outGoingModel)
    }
}
