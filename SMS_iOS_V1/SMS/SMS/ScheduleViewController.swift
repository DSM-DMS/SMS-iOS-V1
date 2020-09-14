import UIKit
import FSCalendar
import RxSwift

class ScheduleViewController: UIViewController {
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    private var firstDate: Date?
    var holidayArr = ["2020-09-02","2020-09-03"]
    var diffDate = String()
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월"
        return formatter
    }()
    
    lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var changeViewBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var timeScheduleView: TimecScheduleXib!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarSetting()
        self.tableViewSetting()
        timeScheduleView.isHidden = true
    }
    
    @IBAction func changeScheduleAndAcademicSchedule (_ sender: UIButton) {
        if sender.isSelected {
            self.changeHidden(value: true)
        } else {
            self.changeHidden(value: false)
        }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func previousBtn (_ sender: UIButton) {
        let previous = Calendar.current.date(byAdding: .month, value: -1, to: calendarView.currentPage)!
        yearLabel.text = dateFormatter.string(from: previous)
        self.calendarView.setCurrentPage(previous, animated: true)
    }
    
    @IBAction func nextBtn (_ sender: UIButton) {
        let next = Calendar.current.date(byAdding: .month, value: +1, to: calendarView.currentPage)!
        yearLabel.text = dateFormatter.string(from: next)
        self.calendarView.setCurrentPage(next, animated: true)
    }
    
    func calendar (_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let a = dateFormatter2.string(from: date)
        if holidayArr.contains(a) {
            return 1
        }
        return 0
    }
    
    func calendar (_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        var selectionLayer: CAShapeLayer!
        let strDate = dateFormatter2.string(from: date)
        var selectionType = SelectionType.none
        let previousDate = dateFormatter2.string(from: Date(timeInterval: -86400, since: date))
        let nextDate = dateFormatter2.string(from: Date(timeInterval: +86400, since: date))
        
        if holidayArr.contains(strDate) {
            if  holidayArr.contains(previousDate) && holidayArr.contains(nextDate) {
                selectionLayer.path = UIBezierPath(rect: selectionLayer.bounds).cgPath
                return UIColor.init(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
            }
            else if holidayArr.contains(previousDate) && holidayArr.contains(nextDate) {
                let corner : UIRectCorner = [.topRight, .bottomRight]
                selectionLayer.path = UIBezierPath(roundedRect: selectionLayer.bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: selectionLayer.frame.width / 2, height: selectionLayer.frame.width / 2)).cgPath
                return UIColor.init(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
            }
            else if holidayArr.contains(nextDate) {
                let corner : UIRectCorner = [.topLeft, .bottomLeft]
                selectionLayer.path = UIBezierPath(roundedRect: selectionLayer.bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: selectionLayer.frame.width / 2, height: selectionLayer.frame.width / 2)).cgPath
                return UIColor.init(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
            }
//            else {
//                let cell = UICollectionView()
//                let diameter: CGFloat = min(selectionLayer.frame.height, selectionLayer.frame.width)
//                self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: cell.contentSize.frame.width / 2 - diameter / 2, y: cell.contentSize.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
//                return UIColor.init(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
//            }
        }
        return nil
    }
}


extension ScheduleViewController:  FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendarSetting() {
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        let ca = calendarView.appearance
        ca.headerMinimumDissolvedAlpha = 0.0;
        ca.caseOptions = [.headerUsesUpperCase, .weekdayUsesSingleUpperCase]
        ca.weekdayTextColor = .black
        calendarView.today = nil
        calendarView.placeholderType = .none
        calendarView.headerHeight = 0
        ca.eventOffset = CGPoint(x: 15, y: -35)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if firstDate == nil {
            firstDate = date
        } else {
            calendar.deselect(firstDate!)
            firstDate = nil
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendar.deselect(date)
        firstDate = nil
    }

    func tableViewSetting() {
        self.tableView.tableFooterView = UIView.init(frame: .infinite)
        self.tableView.backgroundColor = UIColor(displayP3Red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        self.tableView.clipsToBounds = true
        self.tableView.layer.cornerRadius = 20
        self.tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    func setTableViewHeight(count: Int = 1) -> CGFloat {
        return CGFloat(Double(count) * 44.5)
    }
    
    func changeHidden(value: Bool) {
        leftBtn.isHidden = !value
        rightBtn.isHidden = !value
        calendarView.isHidden = !value
        tableView.isHidden = !value
        timeScheduleView.isHidden = value
    }
}

// 연속으로 이어진 날짜 처리
// 스와이프해도 날짜 바뀌게
