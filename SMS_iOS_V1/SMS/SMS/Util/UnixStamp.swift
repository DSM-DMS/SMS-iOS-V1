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
