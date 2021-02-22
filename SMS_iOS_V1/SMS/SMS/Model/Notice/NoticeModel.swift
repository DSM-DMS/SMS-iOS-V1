//
//  NoticeModel.swift
//  SMS
//
//  Created by DohyunKim on 2021/02/03.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation

struct NoticeModel: Codable {
    let status: Int
    let code: Int?
    let message: String
    let announcements: [Announcements]?
    let size: Int?
}

struct Announcements: Codable {
    let announcement_uuid: String
    let number: Int
    let title: String
    let date: Int
    let views: Int
    let writer_name: String
    let is_checked: Int
}
