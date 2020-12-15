//
//  UnixStamp.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/14.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

func UnixStampToDate(with unixInt: Int) -> String {
    return globalDateFormatter(formType(rawValue: formType.time.rawValue)!).string(from: Date(timeIntervalSince1970: TimeInterval(unixInt)))
}

func DateToUnixStamp(with date: String) -> Int {
    return Int(globalDateFormatter(formType(rawValue: formType.untilDay.rawValue)!).date(from: date)!.timeIntervalSince1970)
}
