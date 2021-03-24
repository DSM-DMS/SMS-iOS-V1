//
//  NoticeSearchModel.swift
//  SMS
//
//  Created by 이현욱 on 2021/03/25.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation

struct NoticeSearchModel: Codable {
    let status: Int
    let code: Int
    let message: String
    let announcement_uuid: String
    let number: Int
    let title: String
    let date: Int
    let views: Int
    let writer_name: String
    let is_checked: Int
    let size: Int
}
