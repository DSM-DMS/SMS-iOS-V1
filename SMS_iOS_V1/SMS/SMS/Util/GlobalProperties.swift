//
//  GlobalProperties.swift
//  SMS
//
//  Created by 이현욱 on 2020/10/11.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit
import KeychainSwift

let keyChain = KeychainSwift()

func checking<T: Comparable>(e1: T, e2: T) -> Bool {
    return e1 >= e2
}

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

func datecommponent( _ date: Date) -> DateComponents {
    return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
}

func globalDateFormatter(_  formType: formType, _ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.timeZone = TimeZone.autoupdatingCurrent
    formatter.dateFormat = formType.rawValue
    return formatter.string(from: date)
}

func globalDateFormatter(_  formType: formType, _ date: String) -> Date {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.timeZone = TimeZone.autoupdatingCurrent
    formatter.dateFormat = formType.rawValue
    return formatter.date(from: date)!
}

func globalDateFormatter(_  formType: formType, _ date: Date) -> Date {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.timeZone = TimeZone.autoupdatingCurrent
    formatter.dateFormat = formType.rawValue
    let strDate = formatter.string(from: date)
    return formatter.date(from: strDate)! + 32400
}

func dateIntArr(_ date: String) -> [Int] {
    return date.split { $0 == " " }
        .map { dateArr in
            Int(dateArr.dropLast())!
        }
}

func dateStr(_ date: String) -> String {
   let components = date.split { $0 == " " }
        .map { dateArr in
            Int(dateArr.dropLast())!
        }
    
    var string = ""
    for i in 0..<components.count - 1 {
        string += "\(components[i])-"
    }
    string += String(components[components.count - 1])
    return string
}

enum formType: String {
    case dotDay = "yyyy.M.dd"
    case day = "yyyy년 M월 d일"
    case month = "yyyy년 M월"
    case untilDay = "yyyy-M-d"
    case time = "HH:mm"
    case untilSecTime = "HH:mm:ss"
    case detailTime = "M.d"
}
