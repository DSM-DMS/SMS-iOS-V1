//
//  NoticeSearchViewModel.swift
//  SMS
//
//  Created by 이현욱 on 2021/04/16.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class NoticeSearchViewModel {
    let input: Input
    let output: Output
    let networking: Networking
    
    struct Input {
        let searchTextSubject = BehaviorSubject<String>(value: "")
    }
    
    struct Output {
        let announcements: Observable<NoticeModel>
    }
    
    init(networking: Networking) {
        self.networking = networking
        input = Input()
        
        output = Output(announcements: input.searchTextSubject
                            .flatMapLatest { txt -> Observable<NoticeModel> in
                                networking.networking(from: .searchNotice(txt))
                            })
    }
}
