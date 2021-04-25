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
    let networking: Networking
    
    let reasonSubject = PublishSubject<String>()
    let startTimeSubject = PublishSubject<Date>()
    let endTimeSubject = PublishSubject<Date>()
    let placeSubject = PublishSubject<String?>()
    let applySubject = PublishSubject<Void>()
    let diseaseIsSubject = PublishSubject<Bool>()
    
    let response: Observable<OutGoingModel>
    let isValid: Signal<Bool>
    
    init(networking: Networking) {
        self.networking = networking
        
        self.response = applySubject
            .withLatestFrom(
                Observable.combineLatest(startTimeSubject.startWith(Date()),
                                         endTimeSubject.startWith(Date()),
                                         placeSubject,
                                         reasonSubject,
                                         diseaseIsSubject.startWith(false)
                )
            )
            .map { txt -> SMSAPI in
                let str = txt.4 ? "emergency" : "normal"
                
                return SMSAPI.postOuting(Int(txt.0.timeIntervalSince1970), Int(txt.1.timeIntervalSince1970), txt.2!, txt.3, str)
            }.flatMap { request -> Observable<OutGoingModel> in
                networking.networking(from: request)
            }
        
        self.isValid = Observable.combineLatest(placeSubject,
                                                reasonSubject)
            .map { place, reason in
                let nPlace = place ?? ""
                return !nPlace.isEmpty && !reason.isEmpty
            }.asSignal(onErrorJustReturn: false)
    }
}
