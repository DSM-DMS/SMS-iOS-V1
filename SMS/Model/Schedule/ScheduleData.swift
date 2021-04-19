//
//  ScheduleData.swift
//  SMS
//
//  Created by 이현욱 on 2021/02/16.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation

struct ScheduleData: Hashable, Equatable {
    let start: Date
    let uuid: String
    let date: Date
    let detail: String
    let detailDate: String
    let selected: Bool
    let place: Int?
}

extension ScheduleData {
    func contain(_ date: Date) -> Bool {
        return self.date == date
    }
}
