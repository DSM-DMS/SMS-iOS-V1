//
//  OutLocationModel.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/24.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import Foundation

struct OutLocationModel: Codable {
    let status: Int
    let code: Int
    let lastBuildDate: String
    let message: String
    let start: Int
    let total: Int
    let display: Int
    let item: [itmesArr]
}

struct itmesArr: Codable {
    let title: String
    let link: String
    let category: String
    let telephone: String
    let address: String
    let roadAddress: String
    let mapx: String
    let mapy: String
}
