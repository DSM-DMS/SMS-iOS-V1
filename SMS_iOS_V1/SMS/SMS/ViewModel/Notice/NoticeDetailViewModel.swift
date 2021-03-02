//
//  NoticeDetailViewModel.swift
//  SMS
//
//  Created by DohyunKim on 2021/02/22.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class NoticeDetailViewModel {
//    func uuidGetter() {
//        UserDefaults.standard.setValue(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
//    } 이거 공지 누를때 넣어주기
    let NoticeDetailData: Observable<MypageModel> = SMSAPIClient.shared.networking(from: SMSAPI.detailNotice)
}
