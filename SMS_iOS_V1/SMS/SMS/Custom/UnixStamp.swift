//
//  UnixStamp.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/14.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

func unix(with unixInt: Int) -> DateComponents {
    let date = Date(timeIntervalSince1970: TimeInterval(unixInt - 32400))
    return Calendar.current.dateComponents([.year, .month , .day, .hour, .minute], from: date)
}

func unix(with dateStr: String) -> Int {
    let date = DateFormatter().date(from: dateStr)!
    return Int(date.timeIntervalSince1970)
}

func stringToUnix(with time: String) -> Int { 
    let end = time.index(time.endIndex, offsetBy: -4)
    let timeArr = time[time.startIndex...end]
    
    let components = timeArr.split { $0 == ":" } .map { (x) -> Int in return Int(String(x))! }
    return components[0] * 3600 + components[1] * 60
}
