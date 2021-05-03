//
//  RegisterModel.swift
//  SMS
//
//  Created by 이현욱 on 2021/02/26.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation

struct RegisterModel: Codable {
    let status: Int
    let code: Int
    let message: String
    let student_uuid: String?
}