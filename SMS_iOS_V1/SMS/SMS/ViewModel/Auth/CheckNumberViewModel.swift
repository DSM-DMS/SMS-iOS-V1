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

class CheckNumberViewModel: ViewModelType {
    struct Input {
        let numberDriver: Driver<String>
        let checkDrvier: Driver<Void>
    }
    
    struct Output {
        let certificationNumberModel: Observable<CertificationNumberModel>
    }
    
    func transform(_ input: Input) -> Output {
        let numberTextField = input.numberDriver.asObservable()
        
        let model = input.checkDrvier.asObservable()
            .withLatestFrom(numberTextField)
            .flatMap { number -> Observable<CertificationNumberModel> in
                SMSAPIClient.shared.networking(from: .certificationNumber(number))
            }
        
        return Output(certificationNumberModel: model)
    }
    
    func isValid(_ input: Input) -> Observable<Bool> {
        return input.numberDriver.asObservable()
            .map { number in
                return number.count == 6
        }
    }
}
