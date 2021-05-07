//
//  NoticeDetailViewModel.swift
//  SMS
//
//  Created by 이현욱 on 2021/04/16.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

class NoticeDetailViewModel {
    let input: Input
    let output: Output
    let networking: Networking
    
    struct Input {
        let noticeUUIDSubject = BehaviorSubject<String>(value: "announcement-656755487558")
    }
    
    struct Output {
        let announcements: Observable<NoticeDetailModel>
    }
    
    init(networking: Networking) {
        self.networking = networking
        input = Input()
        
        output = Output(announcements: input.noticeUUIDSubject
                            .flatMapLatest{ uuid -> Observable<NoticeDetailModel> in
                                networking.networking(from: .detailNotice(uuid))
                            }
        )
    }
}

extension NoticeDetailViewModel: asd {
    func tabbedAccount(uuid: String) {
        self.input.noticeUUIDSubject.onNext(uuid)
    }
}
