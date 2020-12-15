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
}

enum OutingState {
    case deny
    case expiration
    case wating
    case approval
    case outing
}
