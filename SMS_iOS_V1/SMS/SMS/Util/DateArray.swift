//
//  DateArray.swift
//  SMS
//
//  Created by 이현욱 on 2021/04/17.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation

public func generateDateRange(from startDate: Date, to endDate: Date) -> [Date] {
    let calendar = Calendar.current
    if startDate > endDate { return [] }
    var returnDates: [Date] = []
    var currentDate = startDate
    repeat {
        returnDates.append(currentDate + 32400)
        currentDate = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: currentDate)!)
    } while currentDate <= endDate
    return returnDates
}
