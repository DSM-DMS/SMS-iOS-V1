//
//  LoginModel.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/04.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import Foundation

struct LoginModel: Codable {
    let status: Int
    let code: Int
    let message: String
    let student_uuid: String?
    let access_token: String?
}
