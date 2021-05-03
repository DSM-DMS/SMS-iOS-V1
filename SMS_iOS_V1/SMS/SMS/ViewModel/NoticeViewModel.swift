//
//  NoticeViewModel.swift
//  SMS
//
//  Created by 이현욱 on 2021/04/16.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class NoticeViewModel {
    let input: Input
    let output: Output
    let networking: Networking
    
    struct Input {
        let viewDidAppear = PublishSubject<Void>()
    }
    
    struct Output {
        let announcements: Observable<NoticeModel>
    }
    
    init(networking: Networking) {
        self.networking = networking
        input = Input()
        
        output = Output(announcements: input.viewDidAppear
                            .flatMapLatest{ request -> Observable<NoticeModel> in
                                networking.networking(from: .lookUpNotice)
                            }
        )
    }
}
