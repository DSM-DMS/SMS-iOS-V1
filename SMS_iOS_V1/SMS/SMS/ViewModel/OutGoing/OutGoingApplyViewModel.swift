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
    let input: Input
    let output: Output
    
    struct Input {
        let reasonSubject = PublishSubject<String>()
        let startTimeSubject = PublishSubject<Date>()
        let endTimeSubject = PublishSubject<Date>()
        let placeSubject = PublishSubject<String?>()
        let applySubject = PublishSubject<Void>()
        let diseaseIsSubject = PublishSubject<Bool>()
    }
    
    struct Output {
        let response: Observable<OutGoingModel>
    }
    
    init() {
        input = Input()
        output = Output(response: input.applySubject.asObservable()
                            .withLatestFrom(Observable.combineLatest(input.startTimeSubject.asObservable(),
                                                                     input.endTimeSubject.asObservable(),
                                                                     input.placeSubject.asObservable(),
                                                                     input.reasonSubject.asObservable(),
                                                                     input.diseaseIsSubject.asObservable()
                            ))
                            .filter {
                                let place = $0.2 ?? ""
                                return (!place.isEmpty && !$0.3.isEmpty)
                            }.filter {
                                let start = datecommponent($0.0)
                                let end = datecommponent($0.1)
                                
                                return (start.hour! >= 16 && start.hour! <= 20) && (end.hour! >= 16 && end.hour! <= 20) && (start.hour! == 16 && start.minute! > 19) && (end.hour! == 20 && end.minute! < 31) && (end.hour! > start.hour!)
                            }
                            .map { txt -> SMSAPI in
                                let str = txt.4 ? "emergency" : "normal"
                                return SMSAPI.postOuting(Int(txt.0.timeIntervalSince1970), Int(txt.1.timeIntervalSince1970), txt.2!, txt.3, str)
                            }.flatMap { request -> Observable<OutGoingModel> in
                                return SMSAPIClient.shared.networking(from: request)
                            })
    }
    
    func isValid(_ input: Input) -> Observable<Bool> {
        return Observable.combineLatest(input.startTimeSubject.asObservable(),
                                        input.endTimeSubject.asObservable(),
                                        input.placeSubject.asObservable(),
                                        input.reasonSubject.asObservable())
            .map { start, end, place, reason in
                return !place!.isEmpty && !reason.isEmpty
            }
    }
    
    func timeCheck(_ input: Input) -> Observable<Bool> {
        return input.applySubject.asObservable()
            .withLatestFrom(Observable.combineLatest(input.startTimeSubject.asObservable(),
                                                     input.endTimeSubject.asObservable(),
                                                     input.placeSubject.asObservable(),
                                                     input.reasonSubject.asObservable(),
                                                     input.diseaseIsSubject.asObservable()
            ))
            .map { data in
                let start = datecommponent(data.0)
                let end = datecommponent(data.1)
                return (start.hour! >= 16 && start.hour! <= 20) && (end.hour! >= 16 && end.hour! <= 20) && (start.hour! == 16 && start.minute! > 19) && (end.hour! == 20 && end.minute! < 31) && (end.hour! > start.hour!)
            }
    }
}
