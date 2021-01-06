//
//  ScheduleModel.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/15.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import Foundation

struct ScheduleModel: Codable {
    let code: Int
    let message: String
    let schedules: [Schedules]?
    let status: Int
}

struct Schedules: Codable {
    let detail: String
    let startTime: Int
    let endTime: Int
    let uuid: String
    
    enum CodingKeys: String, CodingKey {
        case detail
        case startTime = "start_date"
        case endTime = "end_date"
        case uuid = "schedule_uuid"
    }
}
