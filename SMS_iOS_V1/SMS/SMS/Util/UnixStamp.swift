//
//  UnixStamp.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/14.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

func unix(with unixInt: Int) -> DateComponents {
    let date = Date(timeIntervalSince1970: TimeInterval(unixInt))
    return Calendar.current.dateComponents([.year, .month , .day, .hour, .minute], from: date)
}

func unix(with dateStr: String) -> Int {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-M-d"
    dateFormatter.locale = Locale(identifier: "ko_KR")
    let date = dateFormatter.date(from: dateStr)
    return Int(date!.timeIntervalSince1970)
}

func unix(with unixInt: Int) -> Date {
    return Date(timeIntervalSince1970: TimeInterval(unixInt))
}

func stringToUnix(with time: String) -> Int {
    let start = time.index(time.startIndex, offsetBy: +5)
    let end = time.index(time.endIndex, offsetBy: -4)
    let asd = time.index(time.endIndex, offsetBy: -2)
    let asds = time.index(time.endIndex, offsetBy: -1)
    
    let am = time[asd...asds]
    let timeString = time[start...end]
    
    let components = timeString.split { $0 == ":" }.map { (x) -> Int in return Int(String(x))! }
    var time = components[0] * 3600 + components[1] * 60
    
    if am == "PM" { time += 43200 }
    return time
}
