//
//  CheckNumberViewModel.swift
//  SMS
//
//  Created by 이현욱 on 2021/02/26.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class CheckNumberViewModel {
    let input: Input
    let output: Output
    let networking: Networking
    
    struct Input {
        let numberSubject = PublishSubject<String>()
        let checkSubject = PublishSubject<Void>()
    }
    
    struct Output {
        let certificationNumberModel: Observable<CertificationNumberModel>
        let buttonIsValid: Signal<Bool>
    }
    
    init(networking: Networking) {
        self.networking = networking
        input = Input()
        output = Output(certificationNumberModel: input.checkSubject.asObservable()
                            .withLatestFrom(input.numberSubject)
                            .flatMapLatest{ number -> Observable<CertificationNumberModel> in
                                networking.networking(from: .certificationNumber(number))
                            },
                        buttonIsValid: input.numberSubject.asObservable()
                            .map { number in
                                return number.count == 6
                            }.asSignal(onErrorJustReturn: false))
    }
}
