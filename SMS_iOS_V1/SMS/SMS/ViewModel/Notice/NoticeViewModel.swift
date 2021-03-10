//
//  NoticeViewModel.swift
//  SMS
//
//  Created by DohyunKim on 2021/02/03.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class NoticeViewModel {
    
    let noticeData: Observable<NoticeModel> = SMSAPIClient.shared.networking(from: SMSAPI.lookUpNotice)
    
}
