//
//  GlobalProperties.swift
//  SMS
//
//  Created by 이현욱 on 2020/10/11.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

let globalDateFormatter = { (formStr: formType) -> DateFormatter in
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = formStr.rawValue
    return formatter
}

enum formType: String {
    case month = "yyyy년 MM월"
    case day = "yyyy-MM-dd"
}
