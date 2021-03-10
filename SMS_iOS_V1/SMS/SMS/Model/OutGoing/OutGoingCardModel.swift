//
//  OutGoingCardModel.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/23.
//  Copyright © 2020 DohyunKim. All rights reserved.
//


import Foundation

struct OutGoingCardModel: Codable {
    let status: Int
    let code: Int
    let message: String
    let outing_uuid: String?
    let place: String?
    let start_time: Int?
    let end_time: Int?
    let outing_status: String?
    let name: String?
    let grade: Int?
    let group: Int?
    let number: Int?
    let profile_uri: String?
}
