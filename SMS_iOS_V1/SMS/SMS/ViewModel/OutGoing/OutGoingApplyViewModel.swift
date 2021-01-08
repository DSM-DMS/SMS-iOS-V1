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
        let applyDriver: Driver<Void>
        let diseaseIs: Bool
    }
    
    struct Output {
        let response: Observable<OutGoingModel>
    }
    
    func transform(_ input: Input) -> Output {
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
                if input.diseaseIs {
                    str = "emergency"
                }
                
                let components = dateIntArr(txt.0)
                
                let date = "\(components[0])-\(components[1])-\(components[2])"
                return SMSAPI.postOuting(unix(with: date) + stringToUnix(with: txt.1), unix(with: date) + stringToUnix(with: txt.2), txt.3, txt.4, str)
            }.flatMap { request -> Observable<OutGoingModel> in
                return SMSAPIClient.shared.networking(from: request)
            }
        
        return Output(response: outGoingModel)
    }
}
