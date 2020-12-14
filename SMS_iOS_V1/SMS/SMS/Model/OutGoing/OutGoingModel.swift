//
//  OutGoingModel.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/11.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import Foundation

struct OutGoingModel: Codable {
    let status: Int
    let code: Int
    let message: String
    let outing_uuid: String
}
