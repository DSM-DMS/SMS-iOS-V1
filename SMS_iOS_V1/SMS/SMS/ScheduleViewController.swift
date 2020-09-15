import UIKit
import FSCalendar
import RxSwift

class ScheduleViewController: UIViewController {
    private var firstDate: Date?
    var holidayArr = ["2020-09-02","2020-09-03","2020-09-04","2020-09-06"]
    
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
    
    @IBOutlet weak var headerView: FSCalendarHeaderView!
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
        calendarView.delegate = self
        calendarView.dataSource = self
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
}

//MARK - extension

extension ScheduleViewController:  FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar (_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let a = dateFormatter2.string(from: date)
        if holidayArr.contains(a) {
            return 1
        }
        return 0
    }

    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarView.frame.size.height = bounds.height

    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        let calCell = (cell as! CalendarCollectionViewCell)
        let strDate = dateFormatter2.string(from: date)
        if position == .current {
            var selectionType = SelectionType.none
            if holidayArr.contains(strDate){
                let previousDate = dateFormatter2.string(from: Date(timeInterval: -86400, since: date))
                let nextDate = dateFormatter2.string(from: Date(timeInterval: +86400, since: date))
                let date = dateFormatter2.string(from: date)
                if holidayArr.contains(strDate) {
                    if holidayArr.contains(previousDate) && holidayArr.contains(nextDate) {
                        selectionType = .middle
                    } else if holidayArr.contains(previousDate) && holidayArr.contains(date) {
                        selectionType = .rightBorder
                    } else if holidayArr.contains(nextDate) {
                        selectionType = .leftBorder
                    } else {
                        selectionType = .single
                    }
                }
            } else {
                selectionType = .none
            }
            if selectionType == .none {
                calCell.eventLayer!.isHidden = true
                return
            }
            calCell.eventLayer!.isHidden = false
            calCell.selectionType = selectionType
        } else {
            calCell.eventLayer!.isHidden = true
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.configureVisibleCells()
        if firstDate == nil {
            firstDate = date
        } else {
            calendar.deselect(firstDate!)
            firstDate = nil
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.configureVisibleCells()
        calendar.deselect(date)
        firstDate = nil
    }
    
    private func configureVisibleCells() {
           calendarView.visibleCells().forEach { (cell) in
               let date = calendarView.date(for: cell)
               let position = calendarView.monthPosition(for: cell)
               self.configure(cell: cell, for: date!, at: position)
           }
       }
    
    func tableViewSetting() {
        self.tableView.tableFooterView = UIView.init(frame: .infinite)
        self.tableView.backgroundColor = UIColor(displayP3Red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        self.tableView.clipsToBounds = true
        self.tableView.layer.cornerRadius = 20
        self.tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    func calendarSetting() {
        let ca = calendarView.appearance
        ca.headerMinimumDissolvedAlpha = 0.0;
        ca.caseOptions = [.headerUsesUpperCase, .weekdayUsesSingleUpperCase]
        ca.weekdayTextColor = .black
        calendarView.today = nil
        calendarView.placeholderType = .none
        ca.selectionColor = UIColor.init(displayP3Red: 83/255, green: 35/255, blue: 178/255, alpha: 1)
        ca.eventOffset = CGPoint(x: 15, y: -35)
        calendarView.register(CalendarCollectionViewCell.self, forCellReuseIdentifier: "cell")
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

// 스와이프해도 날짜 바뀌게
