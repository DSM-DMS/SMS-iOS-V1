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
        let startTimeDriver: Driver<String>
        let endTimeDriver:Driver<String>
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
                return (!$0.0.isEmpty && !$0.1.isEmpty && !place.isEmpty && !$0.3.isEmpty)
            }
            .map { txt -> SMSAPI in
                let str = txt.4 ? "emergency" : "normal"
                let dateUnix = unix(with: globalDateFormatter(.dotDay, Date()))
                return SMSAPI.postOuting(dateUnix + stringToUnix(with: txt.0), dateUnix + stringToUnix(with: txt.1), txt.2!, txt.3, str)
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
                return !start.isEmpty && !end.isEmpty && !place!.isEmpty && !reason.isEmpty
            }
    }
}
