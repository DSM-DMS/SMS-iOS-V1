//
//  ScheduleViewModel.swift
//  SMS
//
//  Created by 이현욱 on 2021/04/17.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class ScheduleViewModel {
    let input: Input
    let output: Output
    
    struct Input {
        let viewDidLoad = PublishSubject<Void>()
    }
    
    struct Output {
        let myInfoData: Observable<MypageModel>
        let noticeData: Signal<NoticeModel>
    }
    
    init() {
        input = Input()
        output = Output(myInfoData: input.viewDidLoad
                            .withLatestFrom(Observable.of(())
                                                .flatMap { _ -> Observable<MypageModel> in
                                                    SMSAPIClient.shared.networking(from: .myInfo)
                                                }.asSignal(onErrorJustReturn: MypageModel(status: 0, code: 0, message: "", grade: nil, group: nil, student_number: nil, name: nil, phone_number: nil, profile_uri: nil, parent_status: nil))),
                        noticeData: input.viewDidLoad
                            .withLatestFrom(Observable.of(())
                                                .flatMap { _ -> Observable<NoticeModel> in
                                                    SMSAPIClient.shared.networking(from: .myInfo)
                                                }).asSignal(onErrorJustReturn: NoticeModel(status: 0, code: nil, message: "", announcements: nil, size: nil)))
    }
}
