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
    
    let NoticeDetailData: Observable<NoticeDetailModel> = SMSAPIClient.shared.networking(from: .detailNotice)
}
