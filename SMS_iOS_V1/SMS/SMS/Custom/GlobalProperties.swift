//
//  GlobalProperties.swift
//  SMS
//
//  Created by 이현욱 on 2020/10/11.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

func getMonday(myDate: Date) -> Date {
    let cal = Calendar.current
    var comps = cal.dateComponents([.weekOfYear, .yearForWeekOfYear], from: myDate)
    comps.weekday = 2 // Monday
    let mondayInWeek = cal.date(from: comps)!
    return mondayInWeek.addingTimeInterval(32400)
}

let globalDateFormatter = { (formStr: formType) -> DateFormatter in
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = formStr.rawValue
    return formatter
}

func globalDateFormatter(_  formType: formType, _ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = formType.rawValue
    return formatter.string(from: date)
}

func globalDateFormatter(_  formType: formType, _ date: String) -> Date {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = formType.rawValue
    return formatter.date(from: date)!
}

func dateStr(_ date: String) -> [Int] {
    return date.split { $0 == " " }
        .map { dateArr in
            Int(dateArr.dropLast())!
        }
}

enum formType: String {
    case month = "yyyy년 M월"
    case untilDay = "yyyy-M-d"
    case time = "HH:mm"
    case untilSecTime = "HH:mm:ss"
}
