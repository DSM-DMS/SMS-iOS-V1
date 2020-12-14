//
//  OutGoingLogModel.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/14.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

struct OutGoingLogModel: Codable {
    let statusCode: Int
    let code: Int
    let message: String
    let uuid: String
    let place: String
    let reason: String
    let startTime: Int
    let endTime: Int
    let situation: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case uuid = "outing_uuid"
        case startTime = "start_time"
        case endTime = "end_time"
        case situation = "outing_situation"
        case status = "outing_status"
    }
}

enum OutingState {
    case deny
    case expiration
    case wating
    case approval
    case outing
}
