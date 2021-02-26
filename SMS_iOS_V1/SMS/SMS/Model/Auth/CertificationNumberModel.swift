//
//  CertificationNumberModel.swift
//  SMS
//
//  Created by 이현욱 on 2021/02/26.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation

struct CertificationNumberModel:Codable {
    let status: Int
    let code: Int
    let message: String
    let grade: Int?
    let group: Int?
    let student_number: Int?
    let name: String?
    let phone_number: String?
}
