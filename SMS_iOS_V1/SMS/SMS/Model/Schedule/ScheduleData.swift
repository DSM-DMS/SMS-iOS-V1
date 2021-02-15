//
//  ScheduleData.swift
//  SMS
//
//  Created by 이현욱 on 2021/02/16.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation

struct ScheduleData: Hashable, Equatable {
    let uuid: String
    let date: Date
    let detail: String
    let place: Int
}
