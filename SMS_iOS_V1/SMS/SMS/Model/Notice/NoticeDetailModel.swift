//
//  NoticeDetailModel.swift
//  SMS
//
//  Created by DohyunKim on 2021/02/22.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation

struct NoticeDetailModel: Codable {
    let status: Int
    let code: Int
    let message: String
    let detail: String?
    let date: Int?
    let title: String?
    let content: String?
    let writer_name: String?
    let next_title: String?
    let next_announcement_uuid: String?
    let previous_title: String?
    let previous_announcement_uuid: String?
    let target_grade: Int?
    let target_group: Int?
}
