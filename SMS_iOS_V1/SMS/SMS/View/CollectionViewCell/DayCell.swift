import UIKit

import FSCalendar

class DayCell: FSCalendarCell {
    var cellEvent: [ScheduleData] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func hiddenAll() {
        event1View.isHidden = true
        event2View.isHidden = true
        event3View.isHidden = true
    }
    
    func todaySet(_ date: Date, _ detail: String) -> [ScheduleData] {
        var detailArr: [String] = []
        var newSchedule: [ScheduleData] = []
        cellEvent.forEach { (data) in
            if !detailArr.contains(detail) {
                newSchedule.append(data)
                detailArr.append(data.detail)
            }
        }
        
        cellEvent = newSchedule
        
        newSchedule.forEach { (data) in
            if data.date != date {
                cellEvent.remove(at: cellEvent.firstIndex(of: data)!)
            }
        }
        return cellEvent.unique
    }
}
