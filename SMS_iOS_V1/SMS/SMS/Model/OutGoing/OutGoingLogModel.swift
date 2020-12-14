//
//  OutGoingLogModel.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/14.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

struct OutGoingLogModel: Codable {
    let code: Int
    let message: String
    let outings: [Outings]?
    let status: Int
}

struct Outings: Codable {
    let outing_uuid: String
    let place: String
    let reason: String
    let start_time: Int
    let end_time: Int
    let outing_situation: String
    let outing_status: String
    
//    enum CodingKeys: String, CodingKey {
//        case uuid = "outing_uuid"
//        case startTime = "start_time"
//        case endTime = "end_time"
//        case situation = "outing_situation"
//        case status = "outing_status"
//        case place
//        case reason
//    }
}

enum OutingState {
    case deny
    case expiration
    case wating
    case approval
    case outing
}
