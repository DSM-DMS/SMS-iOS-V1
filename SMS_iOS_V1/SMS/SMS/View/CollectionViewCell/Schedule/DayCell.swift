import UIKit

import FSCalendar

protocol cellasxd {
    func asd(_ width: State)
}

class DayCell: FSCalendarCell {
    var cellContinuedState: [View] = []
    var cellEvent: [ScheduleData] = []
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    var leading2Constraint: NSLayoutConstraint!
    var trailing2Constraint: NSLayoutConstraint!
    var leading3Constraint: NSLayoutConstraint!
    var trailing3Constraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setting()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setting()
    }
    
    func hiddenAll() {
        event1View.isHidden = true
        event2View.isHidden = true
        event3View.isHidden = true
    }
    
    func todaySet(_ date: Date, _ uuid: String) -> [ScheduleData] {
        var detailArr: [String] = []
        var newSchedule: [ScheduleData] = []
        cellEvent.forEach { (data) in
            if !detailArr.contains(uuid) {
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
    
    func setting() {
        titleLabel.textColor = .label
        
        leadingConstraint = event1View.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0)
        leadingConstraint.isActive = true
        trailingConstraint = event1View.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0)
        trailingConstraint.isActive = true
        event1View.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2).isActive = true
        event1View.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        
        leading2Constraint = event2View.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0)
        leading2Constraint.isActive = true
        trailing2Constraint = event2View.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0)
        trailing2Constraint.isActive = true
        event2View.topAnchor.constraint(equalTo: event1View.bottomAnchor, constant: 1.5).isActive = true
        event2View.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        
        leading3Constraint = event3View.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0)
        leading3Constraint.isActive = true
        trailing3Constraint = event3View.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0)
        trailing3Constraint.isActive = true
        event3View.topAnchor.constraint(equalTo: event2View.bottomAnchor, constant: 1.5).isActive = true
        event3View.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
    }
    
    // 선택했는지 디폴트인지 연결인지 체크, 연결이라면 몇번쨰 뷰가 그런지
    
    func selectedDate(_ width: State, _ view: View? = nil) {
        switch width {
        case .continued:
            if let view = view {
                switch view {
                case .Event1: leadingConstraint.constant = 3
                case .Event2: leading2Constraint.constant = 3
                case .Event3: leading3Constraint.constant = 3
                }
            }
        case .normal:
            trailingConstraint.constant = 0
            leadingConstraint.constant = 0
            trailing2Constraint.constant = 0
            leading2Constraint.constant = 0
            trailing3Constraint.constant = 0
            leading3Constraint.constant = 0
        case .selected:
            trailingConstraint.constant = -3
            leadingConstraint.constant = 3
            trailing2Constraint.constant = -3
            leading2Constraint.constant = 3
            trailing3Constraint.constant = -3
            leading3Constraint.constant = 3
        }
    }
}



enum State {
    case selected
    case normal
    case continued
}

enum View {
    case Event1
    case Event2
    case Event3
}
