//
//  TimeTableModel.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/16.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import Foundation

struct TimeTableModel: Codable {
    let status: Int
    let code: Int
    let message: String
    let time1: String?
    let time2: String?
    let time3: String?
    let time4: String?
    let time5: String?
    let time6: String?
    let time7: String?
}
