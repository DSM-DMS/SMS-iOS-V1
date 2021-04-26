//
//  MyPageViewModel.swift
//  SMS
//
//  Created by 이현욱 on 2021/04/13.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class MyPageViewModel {
    let input: Input
    let output: Output
    let networking: Networking
    
    struct Input {
        let viewDidLoad = PublishSubject<Void>()
    }
    
    struct Output {
        let myInfo: Observable<MypageModel>
    }
    
    init(networking: Networking) {
        self.networking = networking
        
        input = Input()
        output = Output(myInfo: networking.networking(from: .myInfo)
        )
    }
}
