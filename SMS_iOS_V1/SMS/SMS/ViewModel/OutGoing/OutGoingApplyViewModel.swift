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

class OutGoingApplyViewModel: ViewModelType {
    struct Input {
        let reasonDriver: Driver<String>
        let startTimeDriver: Driver<Date>
        let endTimeDriver:Driver<Date>
        let placeDriver: Observable<String?>
        let applyDriver: Driver<Void>
        let diseaseIs: BehaviorRelay<Bool>
    }
    
    struct Output {
        let response: Observable<OutGoingModel>
    }
    
    func transform(_ input: Input) -> Output {
        let outGoingModel = input.applyDriver.asObservable()
            .withLatestFrom(Observable.combineLatest(input.startTimeDriver.asObservable(),
                                                     input.endTimeDriver.asObservable(),
                                                     input.placeDriver.asObservable(),
                                                     input.reasonDriver.asObservable(),
                                                     input.diseaseIs.asObservable()
            ))
            .filter {
                let place = $0.2 ?? ""
                return (!place.isEmpty && !$0.3.isEmpty)
            }.filter {
                let start = datecommponent($0.0)
                let end = datecommponent($0.1)
                
                return (start.hour! == 4 && start.minute! >= 20) || start.hour! >= 16 && start.hour! <= 20 && end.hour! >= start.hour! || (end.minute! <= 30 && end.hour! == 8)
            }
            .map { txt -> SMSAPI in
                let str = txt.4 ? "emergency" : "normal"
                return SMSAPI.postOuting(Int(txt.0.timeIntervalSince1970), Int(txt.1.timeIntervalSince1970), txt.2!, txt.3, str)
            }.flatMap { request -> Observable<OutGoingModel> in
                return SMSAPIClient.shared.networking(from: request)
            }
        
        return Output(response: outGoingModel)
    }
    
    func isValid(_ input: Input) -> Observable<Bool> {
        return Observable.combineLatest(input.startTimeDriver.asObservable(),
                                        input.endTimeDriver.asObservable(),
                                        input.placeDriver.asObservable(),
                                        input.reasonDriver.asObservable())
            .map { start, end, place, reason in
                return !place!.isEmpty && !reason.isEmpty
            }
    }
    
    func asd(_ input: Input) -> Observable<Bool> {
        return input.applyDriver.asObservable()
            .withLatestFrom(Observable.combineLatest(input.startTimeDriver.asObservable(),
                                                     input.endTimeDriver.asObservable(),
                                                     input.placeDriver.asObservable(),
                                                     input.reasonDriver.asObservable(),
                                                     input.diseaseIs.asObservable()
            ))
        .map { data in
            let start = datecommponent(data.0)
            let end = datecommponent(data.1)
                return (start.hour! == 4 && start.minute! >= 20) || start.hour! >= 16 && start.hour! <= 20 && end.hour! >= start.hour! || (end.minute! <= 30 && end.hour! == 8)
        }
    }
}
