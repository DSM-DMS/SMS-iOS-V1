//
//  MypageModel.swift
//  SMS
//
//  Created by DohyunKim on 2021/01/15.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation

struct MypageModel: Codable {
    let status: Int
    let code: Int
    let message: String
    let grade: Int?
    let group: Int?
    let student_number: Int?
    let name: String?
    let phone_number: String?
    let profile_uri: String?
    let parent_status: String?
}
